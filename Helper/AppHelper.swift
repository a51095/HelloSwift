@_exported import AVKit
@_exported import Cache
@_exported import Photos
@_exported import Network
@_exported import SnapKit
@_exported import PhotosUI
@_exported import Alamofire
@_exported import MJRefresh
@_exported import HandyJSON
@_exported import Kingfisher
@_exported import Foundation
@_exported import CoreLocation

/// app沙盒Documents根目录(Documents)
let kAppDocumentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
/// app沙盒Library二级目录(Caches，Preferences)
let kAppCachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
/// app沙盒Tmp根目录(tmp)
let kAppTmpPath = NSTemporaryDirectory()
/// app沙盒Log日志目录
let kAppLogURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Log")

/// UIApplication代理对象
let kAppDelegate = UIApplication.shared.delegate!

/// 屏幕宽
let kScreenWidth = UIScreen.main.bounds.size.width.i
/// 屏幕高
let kScreenHeight = UIScreen.main.bounds.size.height.i

var kLocalization: LocalizationProtocol = Localization()

/// 获取当前窗口栈顶vc
var kTopViewController: UIViewController {
    get {
        let base = kAppDelegate.window!!.rootViewController!

        if let nav = base as? UINavigationController {
            return nav.visibleViewController!
        } else if let tab = base as? UITabBarController {
            return tab.selectedViewController!
        } else if let presented = base.presentedViewController {
            return presented
        } else {
            return base
        }
    }
}

/// 获取当前窗口栈顶nav
var kTopNavigationController: UINavigationController {
    get {
        let rootVC = kAppDelegate.window!!.rootViewController
        if let tab = rootVC as? UITabBarController {
            return tab.selectedViewController as! UINavigationController
        } else {
            return rootVC as! UINavigationController
        }
    }
}

/// 顶部安全间距
func kSafeMarginTop(_ top: Int) -> Int { top + (UIApplication.shared.delegate?.window??.safeAreaInsets.top.i)! }
/// 底部安全间距
func kSafeMarginBottom(_ bottom: Int) -> Int { bottom + (UIApplication.shared.delegate?.window??.safeAreaInsets.bottom.i)! }
/// 等比例设计尺寸宽(以375为基准)
func kScaleWidth(_ width: Int) -> Int { (width * UIScreen.main.bounds.size.width.i / 375) }
/// 等比例设计尺寸高(以667为基准)
func kScaleHeight(_ height: Int) -> Int { (height * UIScreen.main.bounds.size.height.i / 667) }
/// 等比例设计尺寸Size(以375，667为基准)
func kScaleSize(_ width: Int, _ height: Int) -> CGSize {
    let sizeWidth = (width * UIScreen.main.bounds.size.width.i / 375)
    let sizeHeight = (height * UIScreen.main.bounds.size.height.i / 667)
    return CGSize(width: sizeWidth, height: sizeHeight)
}

/// 平方字体-常规体
func kRegularFont(_ size: CGFloat) -> UIFont { UIFont(name:"PingFangSC-Regular", size: size)! }
/// 平方字体-中等体
func kMediumFont(_ size: CGFloat) -> UIFont { UIFont(name:"PingFangSC-Medium", size: size)! }
/// 平方字体-半粗体
func kSemiblodFont(_ size: CGFloat) -> UIFont { UIFont(name:"PingFangSC-Semibold", size: size)! }

/// 用户相机授权状态
func requestAccess(handler: @escaping (Bool) -> (Void))  {
    let status = AVCaptureDevice.authorizationStatus(for: .video)
    switch status {
        case .notDetermined: AVCaptureDevice.requestAccess(for: .video) { res in handler(res) }
        case .authorized: handler(true)
        default: handler(false)
    }
}

/// 用户相册授权状态
func albumAuthorization(handler: @escaping (Bool) -> (Void))  {
    if #available(iOS 14, *) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if status == .authorized || status == .limited {
            handler(true)
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { res in
                if res == .authorized {
                    handler(true)
                } else {
                    handler(false)
                }
            }
        } else {
            handler(false)
        }
    } else {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            handler(true)
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { res in
                if res == .authorized {
                    handler(true)
                } else {
                    handler(false)
                }
            }
        } else {
            handler(false)
        }
    }
}

/// 用户通知授权状态
func requestAuthorization(handler: @escaping (Bool) -> (Void))  {
    let notificationCenter = UNUserNotificationCenter.current()
    // 每次冷启动，先移除所有通知内容，再执行后续操作
    notificationCenter.removeAllDeliveredNotifications()
    notificationCenter.requestAuthorization(options: [.sound, .alert, .badge]) { requestRes, requestErr in
        // 若注册失败，则直接返回，不执行后续操作
        guard requestRes else { return }

        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
                case .notDetermined: // 用户尚未注册通知
                    UIApplication.shared.registerForRemoteNotifications()
                case .authorized:
                    notificationCenter.requestAuthorization(options: [.sound, .alert, .badge]) { requestRes, requestErr in
                        // 用户已授权
                        if requestRes { handler(true) } else { handler(false) }
                    }
                default: handler(false)
            }
        }
    }
}

protocol NetworkStatus { }
extension NetworkStatus {
    /// 基于Alamofire，实时监测网络状态
    var isReachable: Bool {
        get {
            var res: Bool = false
            let netManager = NetworkReachabilityManager()
            if netManager?.status == .reachable(.ethernetOrWiFi) || netManager?.status == .reachable(.cellular) { res = true }
            return res
        }
    }
}

extension NetworkStatus {
    /// 基于NWPathMonitor，实时监测网络状态
    var isNetwork: Bool {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Monitor")
        let semaphore = DispatchSemaphore(value: 0)

        var res: Bool = false

        monitor.pathUpdateHandler = { path in
            res = (path.status == .satisfied)
            semaphore.signal()
        }

        monitor.start(queue: queue)
        semaphore.wait()

        return res
    }
}

/// 在数组中查找指定元素的索引
func findIndex<T: Equatable>(_ value: T, in array: [T]) -> Int? {
    array.firstIndex(of: value)
}

/// 深拷贝
func deepCopy<T: Codable>(_ object: T) -> T? {
    do{
        let jsonData = try JSONEncoder().encode(object)
        return try JSONDecoder().decode(T.self, from: jsonData)
    }
    catch {
        kPrint("Decode failed. \(error)"); return nil
    }
}

/// 延时
@available(iOS 13.0, *)
func delay(_ duration: UInt64) async {
    try? await Task.sleep(nanoseconds: duration * 1000 * NSEC_PER_MSEC)
}

/// 打印调试信息
func kPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
#if DEBUG
    let output = items.map { String(describing: $0) }.joined(separator: separator)
    print(output, terminator: terminator)
#endif
}
