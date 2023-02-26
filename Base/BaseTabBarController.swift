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
    
    /// 初始化器
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    /// 设置整体tabBar样式
    func configBarStyle() {
        // 选项卡是否半透明(默认半透明,建议设置为false)
        tabBar.isTranslucent = false
        // 选项卡背景色
        tabBar.backgroundColor = .white
        // 选项卡选中时,icon与title颜色
        tabBar.tintColor = .orange
        // 选项卡未选中时,icon与title颜色
        tabBar.unselectedItemTintColor = .gray
    }
    
    /// 添加子控制器
    /// - Parameter items: 每个item填充内容
    func addChildController(items: [TabItem]) {
        for ele in items {
            ele.viewController.tabBarItem.title = ele.title
            ele.viewController.tabBarItem.image = UIImage(named: ele.normalName)
            ele.viewController.tabBarItem.selectedImage = UIImage(named: ele.seletedName)
            addChild(ele.viewController)
        }
    }
}
