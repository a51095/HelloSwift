class ExampleUnsplashDetailViewController: BaseViewController, ExampleProtocol {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.25
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(longPressGesture)
        return imageView
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
    }
    
    func setupImageView() {
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: model.full), placeholder: UIImage(named: "placeholder_list_cell_img"))
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
