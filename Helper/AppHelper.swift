//
//  AppHelper.swift
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
@_exported import CoreLocation
@_exported import AAInfographics

// app沙盒Documents根目录(Documents)
let kAppDocumentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
// app沙盒Library二级目录(Caches,Preferences)
let kAppCachesPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last! + "/Caches"
// app沙盒Tmp根目录(tmp)
let kAppTmpPath = NSTemporaryDirectory()

// MARK: 全局的UIApplication代理对象
func kAppDelegate() -> UIApplicationDelegate { UIApplication.shared.delegate! }

// 字体相关
// MARK: 平方字体-常规体
func RegularFont(_ size: CGFloat) -> UIFont { UIFont(name:"PingFangSC-Regular", size: size)! }
// MARK: 平方字体-中等体
func MediumFont(_ size: CGFloat) -> UIFont { UIFont(name:"PingFangSC-Medium", size: size)! }
// MARK: 平方字体-中粗体
func SemiblodFont(_ size: CGFloat) -> UIFont { UIFont(name:"PingFangSC-Semibold", size: size)! }
// MARK: 手写字体-中粗体
func BradleyHandFont(_ size: CGFloat) -> UIFont { UIFont(name:"BradleyHandITCTT-Bold", size: size)! }

// 屏幕尺寸相关
// MARK: 屏幕宽
func kScreenWidth() -> Int { UIScreen.main.bounds.size.width.i }
// MARK: 屏幕高
func kScreenHeight() -> Int { UIScreen.main.bounds.size.height.i }
// MARK: 顶部安全间距
func kSafeMarginTop(_ top: Int) -> Int { top + (UIApplication.shared.delegate?.window??.safeAreaInsets.top.i)! }
// MARK: 底部安全间距
func kSafeMarginBottom(_ bottom: Int) -> Int { bottom + (UIApplication.shared.delegate?.window??.safeAreaInsets.bottom.i)! }
// MARK: 等比例设计尺寸宽(以375为基准)
func kAdaptedWidth(_ width: Int) -> Int { (width * UIScreen.main.bounds.size.width.i / 375) }
// MARK: 等比例设计尺寸高(以667为基准)
func kAdaptedHeight(_ height: Int) -> Int { (height * UIScreen.main.bounds.size.height.i / 667) }

// MARK: 等比例设计尺寸Size(以375,667为基准)
func kScaleSize(_ width: Int, _ height: Int) -> CGSize {
    let sizeWidth = (width * UIScreen.main.bounds.size.width.i / 375)
    let sizeHeight = (height * UIScreen.main.bounds.size.height.i / 667)
    return CGSize(width: sizeWidth, height: sizeHeight)
}

// MARK: 获取当前窗口nav对象
func  kTopNavController() -> UINavigationController {
    let rootVC = kAppDelegate().window!!.rootViewController
    if let tab = rootVC as? UITabBarController {
        return tab.selectedViewController as! UINavigationController
    } else {
        return rootVC as! UINavigationController
    }
}

// MARK: 获取当前窗口vc对象
func kTopViewController(base: UIViewController? = kAppDelegate().window!!.rootViewController) -> UIViewController? {
    if let nav = base as? UINavigationController { return kTopViewController(base: nav.visibleViewController) }
    if let tab = base as? UITabBarController { return kTopViewController(base: tab.selectedViewController) }
    if let presented = base?.presentedViewController { return kTopViewController(base: presented) }
    return base
}

// MARK: 用户相机授权状态
func requestAccess(handler: @escaping (Bool) -> (Void))  {
    let status = AVCaptureDevice.authorizationStatus(for: .video)
    switch status {
    case .notDetermined: AVCaptureDevice.requestAccess(for: .video) { res in handler(res) }
    case .authorized: handler(true)
    default: handler(false)
    }
}

// MARK: 用户相册授权状态
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

// MARK: 实时监测网络状态
protocol NetworkStatus { }
extension NetworkStatus {
    var isReachable: Bool {
        get {
            var res: Bool = false
            let netManager = NetworkReachabilityManager()
            if netManager?.status == .reachable(.ethernetOrWiFi) || netManager?.status == .reachable(.cellular) { res = true }
            return res
        }
    }
}

// MARK: 深拷贝
func codableCopy<T: Codable>(_ obj: T) -> T? {
    do{
        let jsonData = try JSONEncoder().encode(obj)
        return try JSONDecoder().decode(T.self, from: jsonData)
    }
    catch {
        print("Decode failed. \(error)"); return nil
    }
}

