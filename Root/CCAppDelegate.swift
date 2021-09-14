//
//  CCAppDelegate.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/15.
//

extension AppDelegate: CCNetworkStatusProtocol {
    /// 注册APP
    func didFinishLaunchingWithOptions(_ application: UIApplication, _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        window = UIWindow(frame: UIScreen.main.bounds)
        if !isReachable() {
            window?.rootViewController = CCTabBarController()
        } else {
            let adConfig = CCAdConfig(type: .adImage, name: CCAppURL.adImageUrl, url: CCAppURL.adLinkUrl)
            let adViewController = CCAdViewController(config: adConfig)
            adViewController.dismissBlock = { self.window?.rootViewController = CCTabBarController() }
            window?.rootViewController = adViewController
        }
        window?.makeKeyAndVisible()
        requestAuthorization(application)
    }
    
    /// 注册通知
    private func requestAuthorization(_ application: UIApplication)  {
        let notificationCenter = UNUserNotificationCenter.current()
        // 先移除上一条的通知内容
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [AppDelegate.classString()])
        notificationCenter.requestAuthorization(options: [.sound, .alert, .badge]) { requestRes, requestErr in
            // 若注册失败,则直接返回,不执行后续操作
            guard  requestRes else { return }
            
            notificationCenter.getNotificationSettings { settings in
                // 仅在用户未执行"通知"授权时,注册即可
                if (settings.authorizationStatus == .notDetermined) {
                    DispatchQueue.main.async { application.registerForRemoteNotifications() }
                } else if (settings.authorizationStatus == .authorized) {
                    notificationCenter.requestAuthorization(options: [.sound, .alert, .badge]) { requestRes, requestErr in
                        // 用户已授权,添加通知内容
                        if requestRes { self.addNotificationRequest() }
                    }
                }
            }
        }
    }
    
    /// 添加本地通知
    private func addNotificationRequest() {
        
        let notificationCenter = UNUserNotificationCenter.current()
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "每日推送😊"
        notificationContent.body = "推送内容😈"
        notificationContent.sound = .default
        
        var notificationDate = DateComponents()
        notificationDate.hour = 7
        notificationDate.minute = 30
        notificationDate.second = 00
        
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: notificationDate, repeats: true)
        
        let notificationRequest = UNNotificationRequest(identifier: AppDelegate.classString(), content: notificationContent, trigger: notificationTrigger)
        
        notificationCenter.add(notificationRequest, withCompletionHandler: nil)
    }
}
