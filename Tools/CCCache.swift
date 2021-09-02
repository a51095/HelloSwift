//
//  CCCache.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/19.
//

final class CCCache {
    /// 字符串类型缓存"String"
    static var store: Storage = try! Storage(diskConfig: DiskConfig(name: "disk_cache"), memoryConfig: MemoryConfig(), transformer: TransformerFactory.forCodable(ofType: String.self))
    /// 数组字符串类型缓存[String]
    private static var stringArrayStore = store.transformCodable(ofType: [String].self)
    /// 字典类型缓存 [String: Sting]
    private static var stringDicStore = store.transformCodable(ofType: [String: String].self)
    
    /// 存值(String类型)
    static func setString(_ value: String?, forKey: String) {
        guard let value = value else { removeObject(forKey: forKey); return }
        try? store.setObject(value, forKey: forKey)
    }
    
    /// 取值(String类型)
    static func string(key: String) -> String? {
        return try? store.object(forKey: key)
    }
    
    /// 存值(Dictionary类型)
    static func setDictionary(_ dic: [String: Any], forKey: String) {
        guard let jsonValue = dic.jsonString() else { removeObject(forKey: forKey); return }
        try? store.setObject(jsonValue, forKey: forKey)
    }
    
    /// 取值(Dictionary类型)
    static func dictionary(key: String) -> [String: Any]? {
        guard let jsonString = try? store.object(forKey: key), let dict = try? jsonString.toDictionary() as? [String: Any] else { return nil }
        return dict
    }
    
    /// 存值(Array类型)
    static func setArray(_ array: [String]?, forKey: String) {
        guard let value = array else { removeObject(forKey: forKey); return }
        try? stringArrayStore.setObject(value, forKey: forKey)
    }
    
    /// 取值(Array类型)
    static func array(key: String) -> [String]? { try? stringArrayStore.object(forKey: key) }
    
    /// 移除缓存,已key为键
    static func removeObject(forKey key: String) { try? store.removeObject(forKey: key) }
    
    /// 移除所有缓存
    static func removeAll() { try? store.removeAll() }
}

import HandyJSON
extension HandyJSON {
    static func getCache(forKey key: String) -> Self? {
        let jsonString = CCCache.string(key: key)
        return Self.deserialize(from: jsonString)
    }

    func setCache(forKey key: String) {
        let jsonString = toJSONString()
        CCCache.setString(jsonString, forKey: key)
    }
}
