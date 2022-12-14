final class PushManager: NSObject {
    
    // MARK: 注册通知
    static func requestAuthorization(_ application: UIApplication)  {
        let notificationCenter = UNUserNotificationCenter.current()
        // 每次冷启动,先移除所有通知内容,再执行后续操作
        notificationCenter.removeAllDeliveredNotifications()
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
        
    // MARK: 添加本地通知
    static func addNotificationRequest() {
        let notificationCenter = UNUserNotificationCenter.current()
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.sound = .default
        notificationContent.title = "每日推送😊"
        notificationContent.body = "推送内容😈"
        
        var notificationDate = DateComponents()
        notificationDate.hour = 7
        notificationDate.minute = 30
        notificationDate.second = 00
        
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: notificationDate, repeats: true)
        
        let notificationRequest = UNNotificationRequest(identifier: AppDelegate.classString, content: notificationContent, trigger: notificationTrigger)
        
        notificationCenter.add(notificationRequest, withCompletionHandler: nil)
    }
}
