class ExamplePhotoDetailViewController: BaseViewController {
    /// 自适应每个item宽度
    private let autoWidth = kScreenWidth * 0.76
    
    /// 懒加载UIImageView
    private lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    /// 懒加载live照片视图
    private lazy var livePhotoView: PHLivePhotoView = {
        let liveView = PHLivePhotoView()
        liveView.startPlayback(with: .full)
        return liveView
    }()
    
    /// 懒加载视频播放器
    private lazy var playerController: AVPlayerViewController = { AVPlayerViewController() }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(type: PhotoType, source: PHAsset) {
        super.init(nibName: nil, bundle: nil)
        
        switch type {
        case .Image: addImageView(type: type, asset: source)
        case .Gif: addImageView(type: type, asset: source)
        case .Live: addLivePhotoView(asset: source)
        case .Video: addPlayerController(asset: source)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSubview()
        hidesBottomBarWhenPushed = true
    }
    
    private func addImageView(type: PhotoType, asset: PHAsset) {
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: autoWidth, height: autoWidth))
        }
        
        if type == .Image {
            PHImageManager.default().requestImage(for: asset, targetSize: .zero, contentMode: .aspectFill, options: .none) { img, _ in
                self.imageView.image = img
            }
        } else {
            PHImageManager.default().requestImageData(for: asset, options: .none) { resData, _, _, _ in
                if let data = resData {
                    let resArray = UIImage.gif(data)
                    self.imageView.animationImages = resArray.0
                    self.imageView.animationDuration = resArray.1
                    self.imageView.startAnimating()
                } else {
                    self.view.toast("资源有误!")
                }
            }
        }
    }
    
    private func addLivePhotoView(asset: PHAsset) {
        view.addSubview(livePhotoView)
        livePhotoView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: autoWidth, height: autoWidth))
        }
        
        PHImageManager.default().requestLivePhoto(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .default, options: .none) { livePhoto, _ in
            self.livePhotoView.livePhoto = livePhoto
        }
    }
    
    private func addPlayerController(asset: PHAsset) {
        view.addSubview(playerController.view)
        playerController.view.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: autoWidth, height: autoWidth))
        }
        
        PHImageManager.default().requestPlayerItem(forVideo: asset, options: .none) { item, _ in
            let aPlayer = AVPlayer(playerItem: item)
            self.playerController.player = aPlayer
            self.playerController.player?.play()
        }
    }
}
