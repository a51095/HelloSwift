//
//  CCAppHelper.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/15.
//

/// app沙盒Documents根目录(Documents)
let kAppDocumentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
/// app沙盒Library二级目录(Caches,Preferences)
let kAppCachesPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last! + "/Caches"
/// app沙盒Tmp根目录(tmp)
let kAppTmpPath = NSTemporaryDirectory()
/// 全局的UIApplication代理对象
func kAppDelegate() -> AppDelegate { UIApplication.shared.delegate as! AppDelegate }

// MARK: - 字体相关
/// 平方字体-常规体
func RegularFont(_ size: CGFloat) -> UIFont { UIFont(name:"PingFangSC-Regular", size: size)! }
/// 平方字体-中等体
func MediumFont(_ size: CGFloat) -> UIFont { UIFont(name:"PingFangSC-Medium", size: size)! }
/// 平方字体-中粗体
func SemiblodFont(_ size: CGFloat) -> UIFont { UIFont(name:"PingFangSC-Semibold", size: size)! }

// MARK: - 屏幕尺寸相关
/// 屏幕宽
func kScreenWidth() -> CGFloat { UIScreen.main.bounds.size.width }
/// 屏幕高
func kScreenHeight() -> CGFloat { UIScreen.main.bounds.size.height }
/// 顶部安全间距
func kSafeMarginTop(_ top: CGFloat) -> CGFloat { top + (UIApplication.shared.delegate?.window??.safeAreaInsets.top)! }
/// 底部安全间距
func kSafeMarginBottom(_ bottom: CGFloat) -> CGFloat { bottom + (UIApplication.shared.delegate?.window??.safeAreaInsets.bottom)! }
/// 等比例设计尺寸宽(以375为基准)
func kAdaptedWidth(_ width: CGFloat) -> CGFloat { ceil((width * UIScreen.main.bounds.size.width / 375.0)) }
/// 等比例设计尺寸高(以667为基准)
func kAdaptedHeight(_ height: CGFloat) -> CGFloat { ceil((height * UIScreen.main.bounds.size.height / 667.0)) }

/// 等比例设计尺寸Size(以375,667为基准)
func kScaleSize(_ width: CGFloat, _ height: CGFloat) -> CGSize {
    let sizeWidth = ceil((width * UIScreen.main.bounds.size.width / 375.0))
    let sizeHeight = ceil((height * UIScreen.main.bounds.size.height / 667.0))
    return CGSize(width: sizeWidth, height: sizeHeight)
}

/// 获取当前窗口nav对象
func  kTopNavController() -> UINavigationController {
    let rootVC = kAppDelegate().window!.rootViewController
    if let tab = rootVC as? UITabBarController {
        return tab.selectedViewController as! UINavigationController
    } else {
        return rootVC as! UINavigationController
    }
}

/// 获取当前窗口vc对象
func kTopViewController(base: UIViewController? = kAppDelegate().window?.rootViewController) -> UIViewController? {
    if let nav = base as? UINavigationController { return kTopViewController(base: nav.visibleViewController) }
    if let tab = base as? UITabBarController { return kTopViewController(base: tab.selectedViewController) }
    if let presented = base?.presentedViewController { return kTopViewController(base: presented) }
    return base
}

/// 网络状态协议
protocol CCNetworkStatusProtocol {
    func isReachable() -> Bool
    
}

extension CCNetworkStatusProtocol {
    /// 返回一个布尔值,用于实时监测网络状态
    func isReachable() -> Bool {
        var res: Bool = false
        let netManager = NetworkReachabilityManager()
        if netManager?.status == .reachable(.ethernetOrWiFi) || netManager?.status == .reachable(.cellular) { res = true }
        return res
    }
}
