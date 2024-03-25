final class Cache {
    private init() { }
    /// 字符串类型缓存: String
    private static let manager: Storage = try! Storage<String, String>(diskConfig: DiskConfig(name: "DiskCache"), memoryConfig: MemoryConfig(), transformer: TransformerFactory.forCodable(ofType: String.self))
    /// 布尔类型缓存:  Bool
    private static let boolStore = manager.transformCodable(ofType: Bool.self)
    /// 字符串数组类型缓存:  [String]
    private static let stringArrayStore = manager.transformCodable(ofType: [String].self)
    /// 字符串字典类型缓存:  [String: Sting]
    private static let stringDicStore = manager.transformCodable(ofType: [String: String].self)
    
    /// 存值(String)
    static func setString(_ value: String, forKey key: String) {
        try? manager.setObject(value, forKey: key)
    }
    
    /// 取值(String)
    static func string(by key: String) -> String? {
        try? manager.object(forKey: key)
    }
    
    /// 存值(Bool)
    static func setBoolValue(_ value: Bool, forKey key: String) {
        try? boolStore.setObject(value, forKey: key)
    }
    
    /// 取值(Bool)
    static func boolValue(by key: String) -> Bool {
        let res = try? boolStore.object(forKey: key)
        return res ?? false
    }
    
    /// 存值(字符串型数组)
    static func setArray(_ array: [String], forKey key: String) {
        try? stringArrayStore.setObject(array, forKey: key)
    }
    
    /// 取值(字符串型数组)
    static func array(by key: String) -> [String]? {
        try? stringArrayStore.object(forKey: key)
    }
    
    /// 存值(字符串型字典)
    static func setDictionary(_ dic: [String: String], forKey key: String) {
        try? stringDicStore.setObject(dic, forKey: key)
    }
    
    /// 取值(字符串型字典)
    static func dictionary(by key: String) -> [String: Any]? {
        try? stringDicStore.object(forKey: key)
    }
    
    /// 移除缓存
    static func removeObject(by key: String) { try? manager.removeObject(forKey: key) }
    
    /// 移除所有缓存
    static func removeAll() { try? manager.removeAll() }
}

extension HandyJSON {
    /// 取值(模型)
    static func getCache(forKey key: String) -> Self? {
        let jsonString = Cache.string(by: key)
        return Self.deserialize(from: jsonString)
    }
    
    /// 存值(模型)
    func setCache(forKey key: String) {
        guard let jsonString = toJSONString() else { return }
        Cache.setString(jsonString, forKey: key)
    }
}
