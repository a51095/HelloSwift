//
//  CCAppHelper.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/15.
//

@_exported import AVKit
@_exported import Cache
@_exported import Photos
@_exported import SnapKit
@_exported import PhotosUI
@_exported import Alamofire
@_exported import MJRefresh
@_exported import HandyJSON
@_exported import Kingfisher
@_exported import Foundation
@_exported import AAInfographics

/// app沙盒Documents根目录(Documents)
let kAppDocumentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
/// app沙盒Library二级目录(Caches,Preferences)
let kAppCachesPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last! + "/Caches"
/// app沙盒Tmp根目录(tmp)
let kAppTmpPath = NSTemporaryDirectory()
/// 全局的UIApplication代理对象
func kAppDelegate() -> UIApplicationDelegate { UIApplication.shared.delegate! }

// MARK: - 字体相关
/// 平方字体-常规体
func RegularFont(_ size: CGFloat) -> UIFont { UIFont(name:"PingFangSC-Regular", size: size)! }
/// 平方字体-中等体
func MediumFont(_ size: CGFloat) -> UIFont { UIFont(name:"PingFangSC-Medium", size: size)! }
/// 平方字体-中粗体
func SemiblodFont(_ size: CGFloat) -> UIFont { UIFont(name:"PingFangSC-Semibold", size: size)! }
/// 手写字体-中粗体
func BradleyHandFont(_ size: CGFloat) -> UIFont { UIFont(name:"BradleyHandITCTT-Bold", size: size)! }

// MARK: - 屏幕尺寸相关
/// 屏幕宽
func kScreenWidth() -> Int { UIScreen.main.bounds.size.width.i }
/// 屏幕高
func kScreenHeight() -> Int { UIScreen.main.bounds.size.height.i }
/// 顶部安全间距
func kSafeMarginTop(_ top: Int) -> Int { top + (UIApplication.shared.delegate?.window??.safeAreaInsets.top.i)! }
/// 底部安全间距
func kSafeMarginBottom(_ bottom: Int) -> Int { bottom + (UIApplication.shared.delegate?.window??.safeAreaInsets.bottom.i)! }
/// 等比例设计尺寸宽(以375为基准)
func kAdaptedWidth(_ width: Int) -> Int { (width * UIScreen.main.bounds.size.width.i / 375) }
/// 等比例设计尺寸高(以667为基准)
func kAdaptedHeight(_ height: Int) -> Int { (height * UIScreen.main.bounds.size.height.i / 667) }

/// 等比例设计尺寸Size(以375,667为基准)
func kScaleSize(_ width: Int, _ height: Int) -> CGSize {
    let sizeWidth = (width * UIScreen.main.bounds.size.width.i / 375)
    let sizeHeight = (height * UIScreen.main.bounds.size.height.i / 667)
    return CGSize(width: sizeWidth, height: sizeHeight)
}

/// 获取当前窗口nav对象
func  kTopNavController() -> UINavigationController {
    let rootVC = kAppDelegate().window!!.rootViewController
    if let tab = rootVC as? UITabBarController {
        return tab.selectedViewController as! UINavigationController
    } else {
        return rootVC as! UINavigationController
    }
}

/// 获取当前窗口vc对象
func kTopViewController(base: UIViewController? = kAppDelegate().window!!.rootViewController) -> UIViewController? {
    if let nav = base as? UINavigationController { return kTopViewController(base: nav.visibleViewController) }
    if let tab = base as? UITabBarController { return kTopViewController(base: tab.selectedViewController) }
    if let presented = base?.presentedViewController { return kTopViewController(base: presented) }
    return base
}

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

/// 网络状态协议
protocol NetworkStatusProtocol {
    func isReachable() -> Bool
}

extension NetworkStatusProtocol {
    /// 返回一个布尔值,用于实时监测网络状态
    func isReachable() -> Bool {
        var res: Bool = false
        let netManager = NetworkReachabilityManager()
        if netManager?.status == .reachable(.ethernetOrWiFi) || netManager?.status == .reachable(.cellular) { res = true }
        return res
    }
}
