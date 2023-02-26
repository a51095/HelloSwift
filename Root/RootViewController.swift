//
//  RootViewController.swift
//  HelloSwift
//
//  Created by macbook on 2023/2/26.
//

import Foundation

class RootViewController: BaseTabBarController {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
        self.configBarStyle()
        self.configItemStyle()
    }
    
    /// 设置每个Item内容
    func configItemStyle() {
        var viewControllers = [TabItem]()
        
        let homeVC = TabItem(title: "首页", normalName: "vc_home", seletedName: "vc_home", viewController: BaseNavigationController(rootViewController: HomeViewController()))
        viewControllers.append(homeVC)
        
        let listVC = TabItem(title: "列表", normalName: "vc_list", seletedName: "vc_list", viewController: BaseNavigationController(rootViewController: ListViewController()))
        viewControllers.append(listVC)
        
        let userVC = TabItem(title: "我的", normalName: "vc_user", seletedName: "vc_user", viewController: BaseNavigationController(rootViewController: UserViewController()))
        viewControllers.append(userVC)
        
        addChildController(items: viewControllers)
    }
}