//
//  CCTabBarController.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/15.
//

import UIKit

class CCTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        initData()
    }
    
    // MARK: - 数据初始化
    func initData() {
        // 默认为"true",建议设置为"false"
        tabBar.isTranslucent = false
        // 默认即为"白色"
        tabBar.barTintColor = .white
        // 同时设置选项卡选中时,图片颜色和标签颜色
        tabBar.tintColor = .orange
    }
    
    // MARK: - UI初始化
    func setUI() {
        // 添加首页视图
        addChildController(title: "首页", normalIconName: "vc_home", seletedIconName: "vc_home", vc: CCNavigationController(rootViewController: CCHomeViewController()))
        
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
