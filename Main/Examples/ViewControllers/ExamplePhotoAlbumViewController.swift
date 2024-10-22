class ExamplePhotoAlbumViewController: BaseViewController, ExampleProtocol {
    
    /// 当前选中的第N个相薄源(默认选中第一个)
    private var selectIndex = IndexPath(row: 0, section: 0)
    /// 数据源(guideTableView)
    private var albumSource = [AlbumModel]()
    /// 数据源(photoCollectionView)
    private var photoSource = [PhotoModel]()
    /// 懒加载标题视图
    private lazy var titleButton: UIButton = {
        let button = UIButton()
        button.isSelected = true
        button.layer.cornerRadius = 12
        button.titleLabel?.font = kMediumFont(16)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.setImage(UIImage(named: "photo_arrow_up"), for: .selected)
        button.setImage(UIImage(named: "photo_arrow_down"), for: .normal)
        button.addTarget(self, action: #selector(titleButtonDidSelect), for: .touchUpInside)
        return button
    }()
    /// item限定间距
    private var limitMargin: CGFloat = 4.0
    /// 懒加载item尺寸大小
    private lazy var targetSize: CGSize = {
        let autoWidth = (kScreenWidth - 5 * limitMargin) / 4
        return CGSize(width: autoWidth, height: autoWidth)
    }()
    
    /// 懒加载相薄引导视图
    private lazy var guideTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 88
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(PhotoGuideCell.self, forCellReuseIdentifier: PhotoGuideCell.classString)
        return tableView
    }()
    
    /// 懒加载相薄内容视图
    private lazy var photoCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = targetSize
        flowLayout.sectionInset = UIEdgeInsets(top: limitMargin, left: limitMargin, bottom: limitMargin, right: limitMargin)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressTouchDown))
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = false
        collectionView.addGestureRecognizer(longPress)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PhotoShowCell.self, forCellWithReuseIdentifier: PhotoShowCell.classString)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumAuthorization { res in
            if res {
                DispatchQueue.main.async {
                    self.initSubview()
                    self.initData()
                }
            }
        }
    }
    
    override func initData() {
        // 获取系统相册
        let fetchOptions = PHFetchOptions()
        let assetCollections =  PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: fetchOptions)
        filterAssetCollections(collection: assetCollections)
        
#if !targetEnvironment(simulator)
        // 获取用户自定义相册
        let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: fetchOptions)
        filterAssetCollections(collection: userCollections as! PHFetchResult<PHAssetCollection>)
#endif
        
        // 按照数组长度排序
        albumSource = albumSource.sorted { a, b in a.fetchResult.count > b.fetchResult.count }
        
        let item = albumSource.first
        titleButton.setTitle(item?.title, for: .normal)
        fetchResult(item)
    }
    
    // MARK: 格式化相簿内容
    private func filterAssetCollections(collection: PHFetchResult<PHAssetCollection>) {
        for i in 0..<collection.count {
            // 按照时间升序遍历某个相薄内的照片
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            let assetCollection = collection[i]
            
            // 过滤用户隐私相薄(包括'最近删除')
            if  assetCollection.assetCollectionSubtype.rawValue == 1000000201 ||
                    assetCollection.assetCollectionSubtype == .smartAlbumAllHidden {
                continue
            }
            
            // 过滤Cloud分享类型相薄
            if assetCollection.assetCollectionSubtype == .albumCloudShared {
                continue
            }
            
            let assetFetchResult = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
            // 非空校验(过滤空相薄)
            if assetFetchResult.count > 0 {
                albumSource.append(AlbumModel(title: assetCollection.localizedTitle!, fetchResult: assetFetchResult))
            }
        }
    }
    
    override func initSubview() {
        addTopView()
        addBackButton()
        
        topView.addSubview(titleButton)
        titleButton.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
        }
        
        view.addSubview(photoCollectionView)
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp_bottomMargin)
            make.left.bottom.right.equalToSuperview()
        }
        
        view.addSubview(guideTableView)
        guideTableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp_bottomMargin)
            make.left.bottom.right.equalToSuperview()
        }
        
        guideTableView.alpha = 0
        guideTableView.transform = CGAffineTransform(translationX: 0, y: -kScreenHeight)
    }
    
    /// 结果分类,添加数据源
    func fetchResult(_ item: AlbumModel?) {
        // 非空校验
        guard let item = item else { return }
        
        // 每次切换相薄清空上次数据源
        self.photoSource.removeAll()
        
        // 照片请求参数配置
        let options = PHImageRequestOptions()
        // 指定照片是否可从iCloud下载图像
        options.isNetworkAccessAllowed = false
        // 同步处理图像请求,仅返回一次结果
        options.isSynchronous = true
        // 自动调整图像大小，使其与 targetSize 完全匹配
        options.resizeMode = .exact
        // 提供最高质量的可用图像，而忽略加载所需时长
        options.deliveryMode = .highQualityFormat
        
        item.fetchResult.enumerateObjects { asset, _, _ in
            PHImageManager.default().requestImage(for: asset, targetSize: self.targetSize, contentMode: .aspectFill, options: options) { resImage, _ in
                
                guard let image = resImage else { return }
                
                var photoType: PhotoType = .Image
                
                if asset.mediaType == .image {
                    switch asset.mediaSubtypes {
                    case []:
                        // 通用照片
                        photoType = .Image
                    case .photoHDR:
                        // HDR
                        photoType = .Image
                    case .photoScreenshot:
                        // 截图
                        photoType = .Image
                    default:
                        if asset.mediaSubtypes.rawValue == 64 {
                            // GIF
                            photoType = .Gif
                        } else if asset.mediaSubtypes.rawValue == 520 {
                            // Live Photo
                            photoType = .Live
                        }
                    }
                } else if asset.mediaType == .video {
                    photoType = .Video
                }
                self.photoSource.append(PhotoModel(type: photoType, image: image, asset: asset))
                self.photoCollectionView.reloadData()
            }
        }
    }
    
    /// 展示可选相薄视图
    private func showAnimation() {
        titleButton.isSelected = false
        guideTableView.selectRow(at: selectIndex, animated: true, scrollPosition: .none)
        guideTableView.transform = CGAffineTransform(translationX: 0, y: -kScreenHeight)
        UIView.animate(withDuration: 0.25) {
            self.guideTableView.alpha = 1
            self.guideTableView.transform = .identity
        }
    }
    
    /// 隐藏可选相薄视图
    private func hideAnimation() {
        titleButton.isSelected = true
        UIView.animate(withDuration: 0.25) {
            self.guideTableView.alpha = 0
            self.guideTableView.transform = CGAffineTransform(translationX: 0, y: -kScreenHeight)
        }
    }
    
    /// 切换相薄
    @objc func titleButtonDidSelect() {
        titleButton.isSelected ? showAnimation() : hideAnimation()
    }
    
    /// 长按拖动事件
    @objc func longPressTouchDown(longPress: UILongPressGestureRecognizer) {
        switch longPress.state {
        case .began:
            let indexPath = photoCollectionView.indexPathForItem(at: longPress.location(in: photoCollectionView))
            guard indexPath != nil else { return }
            photoCollectionView.beginInteractiveMovementForItem(at: indexPath!)
        case .changed: photoCollectionView.updateInteractiveMovementTargetPosition(longPress.location(in: photoCollectionView))
        case .ended: photoCollectionView.endInteractiveMovement()
        default: photoCollectionView.cancelInteractiveMovement()
        }
    }
}

extension ExamplePhotoAlbumViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albumSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: PhotoGuideCell.self, for: indexPath)
        let item = albumSource[indexPath.row]
        cell.reloadCell(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hideAnimation()
        let item = albumSource[indexPath.row]
        titleButton.setTitle(item.title, for: .normal)
        selectIndex = indexPath
        fetchResult(item)
    }
}

extension ExamplePhotoAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: PhotoShowCell.self, for: indexPath)
        let photoItem = photoSource[indexPath.item]
        cell.reloadCell(item: photoItem)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = photoSource[indexPath.item]
        let vc = ExamplePhotoDetailViewController(type: item.type, source: item.asset)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = photoSource[sourceIndexPath.item]
        photoSource.remove(at: sourceIndexPath.item)
        photoSource.insert(item, at: destinationIndexPath.item)
    }
}
