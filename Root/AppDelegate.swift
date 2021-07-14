//
//  AppDelegate.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/14.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = CCTabBarController()
        window?.makeKeyAndVisible()
        return true
    }
}

