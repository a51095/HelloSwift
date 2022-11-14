class BaseViewController: UIViewController, NetworkStatus {
    
    /// 自定义顶部视图(默认白色背景色)
    lazy var topView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    /// 自定义返回按钮(默认黑色)
    lazy var backButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.vc_back_black(), for: .normal)
        b.contentEdgeInsets = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
        b.addTarget(self, action: #selector(backButtonDidSeleted), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        setUI()
    }
    
    // 视图初始化(一个空的UI初始化方法,子类可继承重写)
    func setUI() { }
    
    /// 设置视图控制器背景色(默认白色)
    func setBackgroundColor() {
        view.backgroundColor = .white
    }
    
    // 添加自定义顶部视图(默认白色背景色)
    func addTopView() {
        let autoH = kSafeMarginTop(44)
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.height.equalTo(autoH)
            make.top.left.right.equalToSuperview()
        }
    }
    
    // 添加自定义返回按钮(默认黑色)
    func addBackButton() {
        if topView.superview != nil {
            topView.addSubview(backButton)
        }else {
            view.addSubview(backButton)
        }
        
        let autoY = kSafeMarginTop(44) / 2
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
