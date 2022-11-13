final class Cache {
    /// 字符串类型缓存: String
    private static let manager: Storage = try! Storage<String, String>(diskConfig: DiskConfig(name: "DiskCache"), memoryConfig: MemoryConfig(), transformer: TransformerFactory.forCodable(ofType: String.self))
    /// 字符串数组类型缓存: [String]
    private static let stringArrayStore = manager.transformCodable(ofType: [String].self)
    /// 字符串字典类型缓存: [String: Sting]
    private static let stringDicStore = manager.transformCodable(ofType: [String: String].self)
    
    // MARK: 存值(String)
    static func setString(_ value: String?, forKey: String) {
        guard let value = value else { removeObject(forKey: forKey); return }
        try? manager.setObject(value, forKey: forKey)
    }
    
    // MARK: 取值(String)
    static func string(key: String) -> String? {
        return try? manager.object(forKey: key)
    }
    
    // MARK: 存值(字符串型数组)
    static func setArray(_ array: [String]?, forKey: String) {
        guard let value = array else { removeObject(forKey: forKey); return }
        try? stringArrayStore.setObject(value, forKey: forKey)
    }
    
    // MARK: 取值(字符串型数组)
    static func array(key: String) -> [String]? { try? stringArrayStore.object(forKey: key) }
    
    // MARK: 存值(字符串型字典)
    static func setDictionary(_ dic: [String: Any], forKey: String) {
        guard let jsonValue = dic.jsonString() else { removeObject(forKey: forKey); return }
        try? manager.setObject(jsonValue, forKey: forKey)
    }
    
    // MARK: 取值(字符串型字典)
    static func dictionary(key: String) -> [String: Any]? {
        guard let jsonString = try? manager.object(forKey: key), let dict = try? jsonString.toObject() as? [String: Any] else { return nil }
        return dict
    }
    
    // MARK: 移除缓存
    static func removeObject(forKey key: String) { try? manager.removeObject(forKey: key) }
    
    // MARK: 移除所有缓存
    static func removeAll() { try? manager.removeAll() }
}

extension HandyJSON {
    // MARK: 取值(模型)
    static func getCache(forKey key: String) -> Self? {
        let jsonString = Cache.string(key: key)
        return Self.deserialize(from: jsonString)
    }
    
    // MARK: 存值(模型)
    func setCache(forKey key: String) {
        let jsonString = toJSONString()
        Cache.setString(jsonString, forKey: key)
    }
}
