//
//  AppPreferences.swift
//  HelloSwift
//
//  Created by well on 2024/2/22.
//

import Foundation

class AppPreferences {
    static let shared = AppPreferences()
    private init() {}
        
    /// Int 类型
    @UserDefault("launchCount", defaultValue: 0)
    var launchCount: Int
    
    /// String 类型
    @UserDefault("username", defaultValue: "")
    var username: String
    
    /// Bool 类型
    @UserDefault("hasSeenOnboarding", defaultValue: false)
    var hasSeenOnboarding: Bool
    
    /// Date 类型
    @UserDefault("lastSyncDate", defaultValue: Date())
    var lastSyncDate: Date
    
    /// 数组
    @UserDefault("favoriteItems", defaultValue: [])
    var favoriteItems: [String]

    /// 字典
    @UserDefault("userPreferences", defaultValue: [:])
    var userPreferences: [String: Any]
    
    // 可选类型
    @UserDefault("optionalValue", defaultValue: nil)
    var optionalValue: String?
    
    struct UserProfile: Codable {
        var name: String
        var age: Int
        var email: String
    }
    
    /// Codable对象
    @UserDefaultCodable("userProfile", defaultValue: UserProfile(name: "", age: 0, email: ""))
    var userProfile: UserProfile
    
    // 自定义UserDefaults
    @UserDefault("appGroupValue", defaultValue: "", userDefaults: .init(suiteName: "group.com.yourapp")!)
    var appGroupValue: String
}

private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    let userDefaults: UserDefaults
    
    init(_ key: String, defaultValue: T, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
    
    var wrappedValue: T {
        get {
            return userDefaults.object(forKey: key) as? T ?? defaultValue
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                userDefaults.removeObject(forKey: key)
            } else {
                userDefaults.set(newValue, forKey: key)
            }
        }
    }
}

@propertyWrapper
struct UserDefaultCodable<T: Codable> {
    let key: String
    let defaultValue: T
    let userDefaults: UserDefaults
    
    init(_ key: String, defaultValue: T, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
    
    var wrappedValue: T {
        get {
            guard let data = userDefaults.data(forKey: key) else {
                return defaultValue
            }
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                print("Decoding error: \(error)")
                return defaultValue
            }
        }
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                userDefaults.set(data, forKey: key)
            } catch {
                print("Encoding error: \(error)")
            }
        }
    }
}
