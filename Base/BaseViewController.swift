class BaseViewController: UIViewController, NetworkStatus {
    /// 自定义顶部视图(默认白色背景)
    lazy var topView = UIView()
    
    /// 自定义返回按钮(默认黑色箭头)
    lazy var backButton: UIButton = {
        let b = UIButton()
        b.contentEdgeInsets = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
        b.addTarget(self, action: #selector(backButtonDidSeleted), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColor()
    }
    
    /// 设置视图控制器背景色
    /// - Parameter color: 默认白色
    func backgroundColor(_ color: UIColor = .white) {
        view.backgroundColor = color
    }
    
    /// 添加自定义顶部视图
    /// - Parameters:
    ///   - safeHeight: 安全高度
    ///   - color: 背景色，默认白色
    func addTopView(_ safeHeight: Int = 44, _ color: UIColor = .white) {
        let autoY = kSafeMarginTop(safeHeight)
        view.addSubview(topView)
        topView.backgroundColor = color
        topView.snp.makeConstraints { make in
            make.height.equalTo(autoY)
            make.top.left.right.equalToSuperview()
        }
    }
    
    /// 添加自定义返回按钮
    /// - Parameters:
    ///   - safeHeight: 安全高度
    ///   - image: 默认黑色
    func addBackButton(_ safeHeight: Int = 44, _ image: UIImage? = R.image.vc_back_black()) {
        if topView.superview != nil {
            topView.addSubview(backButton)
        }else {
            view.addSubview(backButton)
        }
        
        backButton.setImage(image, for: .normal)
        let autoY = kSafeMarginTop(safeHeight) / 2
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(autoY)
            make.left.equalToSuperview()
        }
    }
    
    // 自定义返回按钮事件
    @objc func backButtonDidSeleted() {
        if self.navigationController?.visibleViewController != nil {
            self.navigationController?.popViewController(animated: true)
        }
        self.dismiss(animated: true)
    }
}
