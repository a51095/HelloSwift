@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var window: UIWindow? = {
        UIWindow(frame: UIScreen.main.bounds)
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        didFinishLaunchingWithOptions(application, launchOptions)
        return true
    }
}

extension AppDelegate: NetworkStatus {
    /// 是否展示开屏引导视图，首次安装时展示
    var showGuided: Bool {
        get {
            !Cache.boolValue(by: AppKey.hasInstallKey)
        }
    }
    
    /// 启动App
    func didFinishLaunchingWithOptions(_ application: UIApplication, _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        if showGuided {
            let resourceArray = ["user_guide01", "user_guide02", "user_guide03", "user_guide04"]
            let guideConfig = GuideConfig(resources: resourceArray)
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
    }
}
