extension AppDelegate: NetworkStatus {
    /// 启动APP
    func didFinishLaunchingWithOptions(_ application: UIApplication, _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        window = UIWindow(frame: UIScreen.main.bounds)

        if isFirst() {
            let resourceArray = ["user_guide01", "user_guide02", "user_guide03", "user_guide04"]
            let guideConfig = GuideConfig(resource: resourceArray)
            window?.rootViewController = GuideViewController(config: guideConfig)
        } else {
            if !isReachable() {
                window?.rootViewController = BaseTabBarController()
            } else {
                let adConfig = AdConfig(type: .adImage, name: AppURL.adImageUrl, url: AppURL.adLinkUrl)
                let adViewController = AdViewController(config: adConfig)
                adViewController.dismissBlock = { self.window?.rootViewController = BaseTabBarController() }
                window?.rootViewController = adViewController
            }
        }
        
        window?.makeKeyAndVisible()
        // 注册通知
        PushManager.requestAuthorization(application)
    }
    
    // 检查用户是否首次安装
    private func isFirst() -> Bool { Cache.string(key: AppKeys.firstKey) == nil }
}
