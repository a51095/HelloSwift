//
//  CCListViewController.swift
//  HelloSwift
//
//  Created by well on 2021/9/24.
//

class CCListViewController: CCViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    /// 当前选中的第N个相薄源(默认选中第一个)
    private var seletedIndex = IndexPath(row: 0, section: 0)
    /// 数据源(guideTableView)
    private var albumSource = [AlbumModel]()
    /// 数据源(photoCollectionView)
    private var photoSource = [PhotoModel]()
    /// 标题视图
    private let titleButton = UIButton()
    
    /// 懒加载相薄引导视图
    private lazy var guideTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 88
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(CCPhotoGuideCell.self, forCellReuseIdentifier: classString())
        return tableView
    }()
    
    /// 懒加载相薄内容视图
    private lazy var photoCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let limitMargin: Int = 4
        let autoWidth = (kScreenWidth() - 5 * limitMargin) / 4
        flowLayout.itemSize = CGSize(width: autoWidth, height: autoWidth)
        flowLayout.sectionInset = UIEdgeInsets(top: limitMargin.cgf, left: limitMargin.cgf, bottom: limitMargin.cgf, right: limitMargin.cgf)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CCPhotoShowCell.self, forCellWithReuseIdentifier: classString())
        return collectionView
    }()
    
    override func viewDidLoad() {
        setBackgroundColor()
        albumAuthorization { res in
            if res {
                DispatchQueue.main.async {
                    self.setUI()
                    self.initData()
                    if self.photoSource.count == 0 { self.titleButton.removeFromSuperview() }
                }
            }
        }
    }
    
    // 格式化相簿内容
    private func filterAssetCollections(collection: PHFetchResult<PHAssetCollection>){
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
    
    func initData() {
        // 获取系统相册
        let  fetchOptions =  PHFetchOptions()
        let  assetCollections =  PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: fetchOptions)
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
        
        // 默认状态
        titleButton.isSelected = true
        titleButton.setImage(R.image.photo_arrow_up(), for: .normal)
        titleButton.adjustImageTitlePosition(.right, spacing: 5)
        self.guideTableView.alpha = 0
        self.guideTableView.transform = CGAffineTransform(translationX: 0, y: -kScreenHeight().cgf)
    }
    
    override func setUI() {
        view.addSubview(photoCollectionView)
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(kSafeMarginTop(36))
            make.left.bottom.right.equalToSuperview()
        }
        
        view.addSubview(guideTableView)
        guideTableView.snp.makeConstraints { make in
            make.top.equalTo(kSafeMarginTop(36))
            make.left.bottom.right.equalToSuperview()
        }
        
        addBarView()
        view.addSubview(titleButton)
        titleButton.layer.cornerRadius = 12
        titleButton.titleLabel?.font = MediumFont(16)
        titleButton.setTitleColor(.black, for: .normal)
        titleButton.addTarget(self, action: #selector(titleButtonDidSeleted), for: .touchUpInside)
        titleButton.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kSafeMarginTop(0))
        }
    }
    
    // 结果分类,添加数据源
    func fetchResult(_ item: AlbumModel?)  {
        // 非空校验
        guard let item = item else { return }
        
        // 每次切换相薄清空上次数据源
        self.photoSource.removeAll()
        
        // 照片请求参数配置
        let options = PHImageRequestOptions()
        options.resizeMode = .fast
        options.isSynchronous = true
        options.deliveryMode = .fastFormat
        options.isNetworkAccessAllowed = false
        
        item.fetchResult.enumerateObjects { asset, idx, info in
            PHImageManager.default().requestImage(for: asset, targetSize: .zero, contentMode: .aspectFill, options: options) { resImg, info in
                
                if asset.mediaType == .image, let img = resImg {
                    
                    // 通用照片
                    if asset.mediaSubtypes.rawValue == 0 {
                        self.photoSource.append(PhotoModel(type: .Image, image: img, asset: asset))
                    }
                    
                    // HDR
                    if asset.mediaSubtypes.rawValue == 2 {
                        self.photoSource.append(PhotoModel(type: .Image, image: img, asset: asset))
                    }
                    
                    // 截图
                    if asset.mediaSubtypes.rawValue == 4 {
                        self.photoSource.append(PhotoModel(type: .Image, image: img, asset: asset))
                    }
                    
                    // GIF
                    if asset.mediaSubtypes.rawValue == 64 {
                        self.photoSource.append(PhotoModel(type: .Gif, image: img, asset: asset))
                    }
                    
                    // live
                    if asset.mediaSubtypes == .photoLive {
                        self.photoSource.append(PhotoModel(type: .Live, image: img, asset: asset))
                    }
                    
                }else if asset.mediaType == .video, let img = resImg {
                    self.photoSource.append(PhotoModel(type: .Video, image: img, asset: asset))
                }
            }
        }
        photoCollectionView.reloadData()
    }
    
    // MARK: tableView代理方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albumSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: classString(),for: indexPath) as! CCPhotoGuideCell
        let item = albumSource[indexPath.row]
        cell.configCell(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissAnimate()
        let item = albumSource[indexPath.row]
        titleButton.setTitle(item.title, for: .normal)
        seletedIndex = indexPath
        titleButton.adjustImageTitlePosition(.right, spacing: 5)
        fetchResult(item)
    }
    
    // MARK: collectionView代理方法
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: classString(), for: indexPath) as! CCPhotoShowCell
        let photoItem = photoSource[indexPath.item]
        cell.configCell(item: photoItem)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = photoSource[indexPath.item]
        let vc = CCPhotoDetailViewController(type: item.type, source: item.asset)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: 私有方法
    /// 展示可选相薄视图
    private func showAnimate()  {
        titleButton.isSelected = false
        titleButton.setImage(R.image.photo_arrow_down(), for: .normal)
        guideTableView.selectRow(at: seletedIndex, animated: true, scrollPosition: .none)
        guideTableView.transform = CGAffineTransform(translationX: 0, y: -kScreenHeight().cgf)
        UIView.animate(withDuration: 0.25) {
            self.guideTableView.alpha = 1
            self.guideTableView.transform = .identity
        }
    }
    
    /// 隐藏可选相薄视图
    private func dismissAnimate()  {
        titleButton.isSelected = true
        titleButton.setImage(R.image.photo_arrow_up(), for: .normal)
        titleButton.adjustImageTitlePosition(.right, spacing: 5)
        UIView.animate(withDuration: 0.25) {
            self.guideTableView.alpha = 0
            self.guideTableView.transform = CGAffineTransform(translationX: 0, y: -kScreenHeight().cgf)
        }
    }
    
    /// 切换相薄
    @objc func titleButtonDidSeleted() {
        titleButton.isSelected ? showAnimate() : dismissAnimate()
    }
}

