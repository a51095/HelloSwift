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
    static var store: Storage = try! Storage(diskConfig: DiskConfig(name: "disk_cache"), memoryConfig: MemoryConfig(), transformer: TransformerFactory.forCodable(ofType: String.self))
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

    class func string(forKey key: String) -> String? {
        return try? store.object(forKey: key)
    }
    
    class func setDic(_ dic: [String: Any], forkey: String) {
        guard let jsonValue = dic.jsonString() else {
            removeObject(forKey: forkey)
            return
        }
        try? store.setObject(jsonValue, forKey: forkey)
    }
    
    class func dic(forKey key: String) -> [String: Any]? {
        guard let jsonString = try? store.object(forKey: key), let dict = try? jsonString.toDict() as? [String: Any] else { return nil }
        return dict
    }
    
    class func setStringArray(_ array: [String]?, forkey: String) {
        guard let value = array else {
            removeObject(forKey: forkey)
            return
        }
        try? stringArrayStore.setObject(value, forKey: forkey)
    }

    class func stringArray(forKey key: String) -> [String]? {
        return try? stringArrayStore.object(forKey: key)
    }

    class func setStringDic(_ dic: [String: String]?, forkey: String) {
        guard let value = dic else {
            removeObject(forKey: forkey)
            return
        }
        try? stringDicStore.setObject(value, forKey: forkey)
    }

    class func stringDic(forKey key: String) -> [String: String]? {
        return try? stringDicStore.object(forKey: key)
    }

    class func removeObject(forKey key: String) {
        try? store.removeObject(forKey: key)
    }

    class func removeAll() { try? store.removeAll() }
}
