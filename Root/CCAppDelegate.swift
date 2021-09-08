//
//  CCAppDelegate.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/15.
//

extension AppDelegate {
    func didFinishLaunchingWithOptions(_ application: UIApplication, _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        window = UIWindow(frame: UIScreen.main.bounds)
        let adConfig = CCAdConfig(type: .adImage, name: CCAppURL.adImageUrl, url: CCAppURL.adLinkUrl)
        let adViewController = CCAdViewController(config: adConfig)
        adViewController.dismissBlock = { self.window?.rootViewController = CCTabBarController() }
        window?.rootViewController = adViewController
        window?.makeKeyAndVisible()
    }
}
