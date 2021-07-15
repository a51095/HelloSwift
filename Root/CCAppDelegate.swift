//
//  CCAppDelegate.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/15.
//

import UIKit
import Foundation

extension AppDelegate {
    func didFinishLaunchingWithOptions(_ application: UIApplication, _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = CCTabBarController()
        window?.makeKeyAndVisible()
    }
}
