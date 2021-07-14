//
//  CCAppHelper.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/14.
//

import UIKit
import Foundation

func MarginTop(_ top: CGFloat) -> CGFloat {
    return top + (UIApplication.shared.delegate?.window??.safeAreaInsets.top)!
}

func MarginBottom(_ bottom: CGFloat) -> CGFloat {
    return bottom + (UIApplication.shared.delegate?.window??.safeAreaInsets.bottom)!
}

func kAdaptedWidth(_ width: CGFloat) -> CGFloat {
    return ceil((width * UIScreen.main.bounds.size.width / 375.0))
}

func kAdaptedHeight(_ height: CGFloat) -> CGFloat {
    return ceil((height * UIScreen.main.bounds.size.height / 667.0))
}

func kScaleSize(_ width: CGFloat, _ height: CGFloat) -> CGSize {
    let sizeWidth = ceil((width * UIScreen.main.bounds.size.width / 375.0))
    let sizeHeight = ceil((height * UIScreen.main.bounds.size.height / 667.0))
    return CGSize(width: sizeWidth, height: sizeHeight)
}

func kScreenWidth() -> CGFloat {
    return UIScreen.main.bounds.size.width
}

func kScreenHeight() -> CGFloat {
    return UIScreen.main.bounds.size.height
}

func RegularFont(_ size: CGFloat) -> UIFont {
    return UIFont(name:"PingFangSC-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
}

func MediumFont(_ size: CGFloat) -> UIFont {
    return UIFont(name:"PingFangSC-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
}

func SemiblodFont(_ size: CGFloat) -> UIFont {
    return UIFont(name:"PingFangSC-Semibold", size: size) ?? UIFont.systemFont(ofSize: size)
}

func kAppdelegate() -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}

func  kTopNavController() -> UINavigationController {
    let rootVC = kAppdelegate().window!.rootViewController
    
    if let tab = rootVC as? UITabBarController {
        return tab.selectedViewController as! UINavigationController
    } else {
        return rootVC as! UINavigationController
    }
}

func kCurrentTopController(base: UIViewController? = kAppdelegate().window?.rootViewController) -> UIViewController? {
    if let nav = base as? UINavigationController {
        return kCurrentTopController(base: nav.visibleViewController)
    }
    if  let tab = base as? UITabBarController {
        return kCurrentTopController(base: tab.selectedViewController)
    }
    if let presented = base?.presentedViewController {
        return kCurrentTopController(base: presented)
    }
    return base
}
