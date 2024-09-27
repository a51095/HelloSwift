class ExampleUnsplashDetailViewController: BaseViewController, ExampleProtocol {
    private var rawImage: UIImage?
    private var isBottomViewShow: Bool = false
    private var dataSource: [ImageFiler] = ImageFiler.allCases
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapPress))
        tapGesture.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGesture)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.25
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(longPressGesture)
        return imageView
    }()
    
    lazy var bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = .clear
        bottomView.isUserInteractionEnabled = true
        return bottomView
    }()
    
    var model: UnsplashModel
    
    init(model: UnsplashModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubview()
        setupImageView()
        loadImageFromURL(urlString: model.regular) { res in
            self.rawImage = res
        }
    }
    
    override func initSubview() {
        addTopView()
        addBackButton()
        topView.backgroundColor = .clear
        backButton.backgroundColor = .clear
        backButton.setImage(UIImage(named: "vc_back_white"), for: .normal)
        view.insertSubview(imageView, at: 0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        view.addSubview(bottomView)
        bottomView.isHidden = true
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        bottomView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        let unsplashView = UnsplashView(url: model.regular, frame: .zero)
        bottomView.addSubview(unsplashView)
        unsplashView.delegate = self
        unsplashView.translatesAutoresizingMaskIntoConstraints = false
        unsplashView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        unsplashView.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        unsplashView.leftAnchor.constraint(equalTo: bottomView.leftAnchor).isActive = true
        unsplashView.rightAnchor.constraint(equalTo: bottomView.rightAnchor).isActive = true
        
        let unsplashButton = UIButton()
        bottomView.addSubview(unsplashButton)
        unsplashButton.layer.cornerRadius = 8
        unsplashButton.backgroundColor = .systemBlue
        unsplashButton.setTitle("完 成", for: .normal)
        unsplashButton.addTarget(self, action: #selector(unsplashButtonAction), for: .touchUpInside)
        unsplashButton.translatesAutoresizingMaskIntoConstraints = false
        unsplashButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        unsplashButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        unsplashButton.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -20).isActive = true
        unsplashButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
    }
    
    private func showBottomViewAnimation() {
        bottomView.isHidden = false
        self.bottomView.transform = CGAffineTransform(translationX: 0, y: self.bottomView.frame.height + self.view.safeAreaInsets.bottom)
        UIView.animate(withDuration: 0.25) {
            self.bottomView.transform = .identity
        } completion: { _ in
            self.isBottomViewShow = true
        }
    }
    
    private func hideBottomViewAnimation() {
        self.bottomView.transform = .identity
        UIView.animate(withDuration: 0.25) {
            self.bottomView.transform = CGAffineTransform(translationX: 0, y: self.bottomView.frame.height + self.view.safeAreaInsets.bottom)
        } completion: { _ in
            self.isBottomViewShow = false
            self.bottomView.isHidden = true
        }
    }
    
    private func setupImageView() {
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: model.regular), placeholder: UIImage(named: "placeholder"))
    }
    
    func loadImageFromURL(urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                kPrint("Error loading image: \(error)")
                completion(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            completion(image)
        }.resume()
    }
    
    @objc func unsplashButtonAction() {
        showTopViewAnimation()
        hideBottomViewAnimation()
    }
    
    @objc func handleTapPress(sender: UITapGestureRecognizer) {
        if sender.state == .ended, !isBottomViewShow {
            hideTopViewAnimation()
            showBottomViewAnimation()
        }
    }
    
    @objc func handleLongPress(sender: UITapGestureRecognizer) {
        if sender.state == .began {
            alert(message: "保存至相册?", dialogType: .yesNo, okCallback: {
                albumAuthorization { value in
                    guard value else {
                        DispatchQueue.main.async {
                            self.view.toast("请在'设置'→'HelloSwift'→'照片'中,开启权限", type: .failure)
                        }
                        return
                    }
                    self.saveImageToPhotosAlbum(self.imageView.image!)
                }
            }, cancelCallback: nil)
        }
    }
    
    private func saveImageToPhotosAlbum(_ image: UIImage) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        } completionHandler: { _, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.view.toast("保存图片失败: \(error.localizedDescription)", type: .failure)
                }
            } else {
                DispatchQueue.main.async {
                    self.view.toast("已保存至相册", type: .success)
                }
            }
        }
    }
}

extension ExampleUnsplashDetailViewController: UnsplashViewDelegate {
    func unsplashView(_ unsplashView: UnsplashView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0: imageView.image =  rawImage
        case 1: imageView.image =  rawImage?.bloomFiler()
        case 2: imageView.image =  rawImage?.sharpenFilter()
        case 3: imageView.image =  rawImage?.grayFilter()
        case 4: imageView.image =  rawImage?.blackFilter()
        case 5: imageView.image =  rawImage?.sketchFilter()
        default: break
        }
    }
}

class UnsplashCell: UICollectionViewCell {
    var photoImageView = UIImageView()
    var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(photoImageView)
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.layer.borderWidth = 2
        photoImageView.layer.cornerRadius = 8
        photoImageView.layer.masksToBounds = true
        photoImageView.layer.borderColor = UIColor.systemGray.cgColor
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .clear
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    override var isSelected: Bool {
        willSet {
            if newValue {
                photoImageView.layer.borderColor = UIColor.systemBlue.cgColor
                titleLabel.textColor = .systemBlue
            } else {
                photoImageView.layer.borderColor = UIColor.systemGray.cgColor
                titleLabel.textColor = .white
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadCell(url: String, type: ImageFiler) {
        photoImageView.kf.indicatorType = .activity
        photoImageView.kf.setImage(with: URL(string: url), placeholder: UIImage(named: "placeholder"))
        let rawImage = photoImageView.image
        switch type {
        case .raw:
            photoImageView.image =  rawImage
            titleLabel.text =  "原 图"
        case .black:
            photoImageView.image =  rawImage?.blackFilter()
            titleLabel.text =  "黑 色"
        case .bloom:
            photoImageView.image =  rawImage?.bloomFiler()
            titleLabel.text =  "柔 和"
        case .gray:
            photoImageView.image =  rawImage?.grayFilter()
            titleLabel.text =  "灰 度"
        case .sharpen:
            photoImageView.image =  rawImage?.sharpenFilter()
            titleLabel.text =  "锐 化"
        case .sketch:
            photoImageView.image =  rawImage?.sketchFilter()
            titleLabel.text =  "素 描"
        }
    }
}

protocol UnsplashViewDelegate: AnyObject {
    func unsplashView(_ unsplashView: UnsplashView, didSelectItemAt indexPath: IndexPath)
}

class UnsplashView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    private var url: String
    private var dataSource: [ImageFiler] = ImageFiler.allCases
    weak var delegate: UnsplashViewDelegate?
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 120)
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceHorizontal = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UnsplashCell.self, forCellWithReuseIdentifier: UnsplashCell.classString)
        return collectionView
    }()
    
    init(url: String, frame: CGRect) {
        self.url = url
        super.init(frame: frame)
        initSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .right)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        delegate?.unsplashView(self, didSelectItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UnsplashCell.classString, for: indexPath) as! UnsplashCell
        let type = dataSource[indexPath.item]
        cell.reloadCell(url: url, type: type)
        return cell
    }
}
