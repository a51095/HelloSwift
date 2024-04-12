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
    /// 是否首次安装应用程序
    private var isFrist: Bool {
        get {
            !Cache.boolValue(by: AppKey.hasInstallKey)
        }
    }
    
    /// 启动App
    private func didFinishLaunchingWithOptions(_ application: UIApplication, _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) { start() }

    /// App启动配置
    private func start() {
        debugLog()
        configLocalization()
        settingRootViewController()
    }

    private func debugLog() {
        if #available(iOS 13.0, *) { Log.start(); Log.debugLog(message: "an debug message") }
    }

    private func configLocalization() {
        if let cacheLanguegeString = Cache.string(by: AppKey.localizationKey) {
            let cacheLanguegeCode = LanguageCode(rawValue: cacheLanguegeString)!
            kLocalization = LanguageCode.settingLanguage(by: cacheLanguegeCode)
        } else {
            let preferredLanguegeCode = LanguageCode.fetchPreferredLanguegeCode()
            kLocalization = LanguageCode.settingLanguage(by: preferredLanguegeCode)
        }
    }

    private func settingRootViewController() {
        if isFrist {
            let resourceArray = ["user_guide01", "user_guide02", "user_guide03", "user_guide04"]
            let guideConfig = GuideConfig(resources: resourceArray)
            window?.rootViewController = GuideViewController(config: guideConfig)
        } else {
            if !isReachable {
                window?.rootViewController = RootViewController()
            } else {
                let adConfig = AdConfig(type: .image, netUrl: AppURL.adImageUrl, linkUrl: AppURL.adLinkUrl)
                let adViewController = AdViewController(config: adConfig)
                adViewController.dismissBlock = { self.window?.rootViewController = RootViewController() }
                window?.rootViewController = adViewController
            }
        }
        window?.makeKeyAndVisible()
    }
}
