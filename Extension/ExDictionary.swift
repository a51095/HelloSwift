//
//  ExDictionary.swift
//  DevHelper
//
//  Created by a51095 on 2021/11/11.
//

public extension Dictionary {
    /// 合并当前字典对象键值对
    mutating func merge(dict: [Key: Value]) {
        for (k, v) in dict { updateValue(v, forKey: k) }
    }
    
    /// 字典转JSON数据(参数为格式美化,默认false)
    func jsonData(prettify: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization
            .WritingOptions()
        return try? JSONSerialization.data(withJSONObject: self, options: options)
    }
    
    /// 字典转JSON字符串(参数为格式美化,默认false)
    func jsonString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization
            .WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}

