//
//  CCTabBarController.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/15.
//

class CCTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.configBarStyle()
    }
    
    // MARK: - 配置tabBar样式
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
    
    // MARK: - UI初始化
    func setUI() {
        // 添加首页视图
        addChildController(title: "首页", normalIconName: "vc_home", seletedIconName: "vc_home", vc: CCNavigationController(rootViewController: CCHomeViewController()))
        
        // 添加列表视图
        addChildController(title: "列表", normalIconName: "vc_list", seletedIconName: "vc_list", vc: CCNavigationController(rootViewController: CCListViewController()))
        
        // 添加用户视图
        addChildController(title: "我的", normalIconName: "vc_user", seletedIconName: "vc_user", vc: CCNavigationController(rootViewController: CCUserViewController()))
    }
    
    private func addChildController(title: String, normalIconName: String, seletedIconName: String, vc: UIViewController) {
        vc.tabBarItem.title = title
        vc.tabBarItem.image = UIImage(named: normalIconName)
        vc.tabBarItem.selectedImage = UIImage(named: seletedIconName)
        addChild(vc)
    }
}
