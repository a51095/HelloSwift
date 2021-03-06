//
//  ExString.swift
//  DevHelper
//
//  Created by a51095 on 2021/11/11.
//

public extension String {
    /// 数字类型字符串转整型(谨慎使用)
    var i: Int? { Int(self) }
        
    static let characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    /// 生成指定位数随机字符串(此处默认16位)
    static func randomString(len : Int) -> String {
        var ranStr = ""
        for _ in 0..<len {
            let index = Int(arc4random_uniform(UInt32(characters.count)))
            ranStr.append(characters[characters.index(characters.startIndex, offsetBy: index)])
        }
        return ranStr
    }
    
    /// 格式化时间字符串
    static func dateFormatter() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = formatter.string(from: Date())
        return dateStr
    }
    
    /// "JSON字符串" 转换成 "对象"类型
    func toObject()  throws -> Any? {
        let data = self.data(using: .utf8)
        // 容错处理
        guard data != nil else { return nil }
        return try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves)
    }
    
    /// 去除字符串中的空格
    func removeAllSapce() -> String { replacingOccurrences(of: " ", with: "") }
    
    /// 版本号比较
    func isHeightVersion(over version: String) -> Bool {
        compare(version, options: .numeric, range: nil, locale: nil) == .orderedDescending
    }
}

// 文件夹相关处理
public extension String {
    func createFoldPath() {
        if !FileManager.default.fileExists(atPath: self) {
            try? FileManager.default.createDirectory(atPath: self, withIntermediateDirectories: true, attributes: nil)
        }
    }
       
    func fileExist() -> Bool {
        return FileManager.default.fileExists(atPath: self)
    }
    
    func moveTo(_ path:String) {
        try? FileManager.default.moveItem(atPath: self, toPath: path)
    }
    
    func copyTo(_ path:String) {
        try? FileManager.default.removeItem(atPath: path)
        try? FileManager.default.copyItem(atPath: self, toPath: path)
    }
    
    func removePath() {
        try? FileManager.default.removeItem(atPath: self)
    }
}
