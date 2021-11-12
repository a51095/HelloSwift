//
//  CCAppDelegate.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/15.
//

extension AppDelegate: NetworkStatusProtocol {
    /// 注册APP
    func didFinishLaunchingWithOptions(_ application: UIApplication, _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
       
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if isFirst() {
            let resourceArray = ["user_guide01", "user_guide02", "user_guide03", "user_guide04"]
            let guideConfig = CCGuideConfig(resource: resourceArray)
            window?.rootViewController = CCGuideViewController(config: guideConfig)
        } else {
            if !isReachable() {
                window?.rootViewController = BaseTabBarController()
            } else {
                let adConfig = CCAdConfig(type: .adImage, name: CCAppURL.adImageUrl, url: CCAppURL.adLinkUrl)
                let adViewController = CCAdViewController(config: adConfig)
                adViewController.dismissBlock = { self.window?.rootViewController = BaseTabBarController() }
                window?.rootViewController = adViewController
            }
        }
        
        window?.makeKeyAndVisible()
        // 注册通知
        CCPushManager.requestAuthorization(application)
    }
    
    /// 检查用户是否首次安装
    private func isFirst() -> Bool { ExCache.string(key: CCAppKeys.firstKey) == nil }

}
