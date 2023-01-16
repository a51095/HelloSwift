class BaseNavigationController: UINavigationController, UINavigationControllerDelegate {
    private var isPush: Bool = false
    
    // MARK: - 反初始化器
    deinit { kPrint("BaseNavigationController deinit") }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.initData()
    }
    
    // MARK: - 数据初始化
    func initData() {
        self.delegate = self
    }
    
    // MARK: - UI初始化
    func setUI() {
        navigationBar.isHidden = true
    }
    
    // MARK: - 导航代理方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // guard校验,若已经push,但未执行完didShow,则返回,不再二次push
        guard !isPush else { return }
        // 设置push状态为true
        isPush = true
        super.pushViewController(viewController, animated: animated)
    }
    
    // MARK: - 避免多次push
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // 执行此代理方法后,重置isPush状态为false,以达到下次可以正常push的目的
        isPush = false
    }
    
    // MARK: - 状态栏样式所属权
    override var childForStatusBarStyle: UIViewController? { topViewController }
}
