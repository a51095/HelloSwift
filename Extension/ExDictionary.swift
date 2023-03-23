extension Dictionary {
    /// 合并字典对象键值对
    /// - Parameter dict: 待合并字典
    mutating func merge(of dic: [Key: Value]) {
        for (k, v) in dic { updateValue(v, forKey: k) }
    }
    
    /// 字典转JSON数据
    /// - Parameter prettify: 格式美化，默认false
    /// - Returns: JSON数据
    func jsonData(prettify: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization
            .WritingOptions()
        return try? JSONSerialization.data(withJSONObject: self, options: options)
    }
    
    /// 字典转JSON字符串
    /// - Parameter prettify: 格式美化，默认false
    /// - Returns: JSON字符串
    func jsonString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization
            .WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}

extension Dictionary where Key: Codable, Value: Codable {
    /// 深拷贝
    var deepCopy: Self {
        do{
            let jsonData = try JSONEncoder().encode(self)
            return try JSONDecoder().decode(Self.self, from: jsonData)
        }
        catch {
            fatalError("Decode failed. \(error)")
        }
    }
}
