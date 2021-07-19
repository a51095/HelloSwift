//
//  CCCache.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/19.
//
import Cache
import Foundation

class CCCache {
    /// 字符串类型缓存"String"
    static var store: Storage = try! Storage(diskConfig: DiskConfig(name: "CCCache"), memoryConfig: MemoryConfig(), transformer: TransformerFactory.forCodable(ofType: String.self))
    /// 数组字符串类型缓存[String]
    private static var stringArrayStore = store.transformCodable(ofType: [String].self)
    /// 字典类型缓存 [String: Sting]
    private static var stringDicStore = store.transformCodable(ofType: [String: String].self)
    
    class func setString(_ value: String?, forkey: String) {
        guard let value = value else {
            removeObject(forKey: forkey)
            return
        }
        try? store.setObject(value, forKey: forkey)
    }

    class func string(forKey: String) -> String? {
        return try? store.object(forKey: forKey)
    }
    
    class func setDic(_ value: [String: Any], forkey: String) {
        guard let jsonValue = value.jsonString() else {
            removeObject(forKey: forkey)
            return
        }
        try? store.setObject(jsonValue, forKey: forkey)
    }
    
    class func dic(forKey: String) -> [String: Any]? {
        guard let jsonString = try? store.object(forKey: forKey), let dict = try? jsonString.toDict() as? [String: Any] else { return nil }
        return dict
    }
    
    class func setStringArray(_ value: [String]?, forkey: String) {
        guard let value = value else {
            removeObject(forKey: forkey)
            return
        }
        try? stringArrayStore.setObject(value, forKey: forkey)
    }

    class func stringArray(forKey: String) -> [String]? {
        return try? stringArrayStore.object(forKey: forKey)
    }

    class func setStringDic(_ value: [String: String]?, forkey: String) {
        guard let value = value else {
            removeObject(forKey: forkey)
            return
        }
        try? stringDicStore.setObject(value, forKey: forkey)
    }

    class func stringDic(forKey: String) -> [String: String]? {
        return try? stringDicStore.object(forKey: forKey)
    }

    class func removeObject(forKey: String) {
        try? store.removeObject(forKey: forKey)
    }

    class func removeAll() {
        try? store.removeAll()
    }
}
