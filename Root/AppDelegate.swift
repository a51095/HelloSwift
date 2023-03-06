@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        didFinishLaunchingWithOptions(application, launchOptions)
        return true
    }
}

extension AppDelegate: NetworkStatus {
    /// 是否展示开屏引导视图，首次安装时展示
    var showGuided: Bool {
        get {
            !Cache.boolValue(by: AppKey.hasInstall)
        }
    }
    
    /// 启动App
    func didFinishLaunchingWithOptions(_ application: UIApplication, _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if showGuided {
            let resourceArray = ["user_guide01", "user_guide02", "user_guide03", "user_guide04"]
            let guideConfig = GuideConfig(resource: resourceArray)
            window?.rootViewController = GuideViewController(config: guideConfig)
        } else {
            if !isReachable {
                window?.rootViewController = RootViewController()
            } else {
                let adConfig = AdConfig(type: .adImage, name: AppURL.adImageUrl, url: AppURL.adLinkUrl)
                let adViewController = AdViewController(config: adConfig)
                adViewController.dismissBlock = { self.window?.rootViewController = RootViewController() }
                window?.rootViewController = adViewController
            }
        }
        
        window?.makeKeyAndVisible()
        // 注册通知
        PushManager.requestAuthorization(application)
    }
}
