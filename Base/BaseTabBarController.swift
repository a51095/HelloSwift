struct TabItem {
    let title: String
    let normalName: String
    let seletedName: String
    let viewController: UIViewController
}

class BaseTabBarController: UITabBarController {
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 初始化器
    init() {
        super.init(nibName: nil, bundle: nil)
        self.configBarStyle()
        self.configItemStyle()
    }

    // MARK: - 配置tabBar样式
    private func configBarStyle() {
        // 选项卡是否半透明(默认半透明,建议设置为false)
        tabBar.isTranslucent = false
        // 选项卡背景色
        tabBar.backgroundColor = .white
        // 选项卡选中时,icon与title颜色
        tabBar.tintColor = .orange
        // 选项卡未选中时,icon与title颜色
        tabBar.unselectedItemTintColor = .gray
    }
    
    // MARK: - 配置tabBar内容
    private func configItemStyle() {
        var viewControllers = [TabItem]()
        
        let homeVC  = TabItem(title: "首页", normalName: "vc_home", seletedName: "vc_home", viewController: BaseNavigationController(rootViewController: HomeViewController()))
        viewControllers.append(homeVC)
        
        let listVC  = TabItem(title: "列表", normalName: "vc_list", seletedName: "vc_list", viewController: BaseNavigationController(rootViewController: ListViewController()))
        viewControllers.append(listVC)
        
        let userVC  = TabItem(title: "我的", normalName: "vc_user", seletedName: "vc_user", viewController: BaseNavigationController(rootViewController: UserViewController()))
        viewControllers.append(userVC)
        
        addChildController(items: viewControllers)
    }
            
    private func addChildController(items: [TabItem]) {
        for ele in items {
            ele.viewController.tabBarItem.title = ele.title
            ele.viewController.tabBarItem.image = UIImage(named: ele.normalName)
            ele.viewController.tabBarItem.selectedImage = UIImage(named: ele.seletedName)
            addChild(ele.viewController)
        }
    }
}
