extension String {
    /// 数字类型字符串转整型(谨慎使用)
    var i: Int? { Int(self) }
    
    static let characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    /// 生成指定位数随机字符串
    static func randomString(len: Int = 6) -> String {
        var ranStr = ""
        for _ in 0..<len {
            let index = Int(arc4random_uniform(UInt32(characters.count)))
            ranStr.append(characters[characters.index(characters.startIndex, offsetBy: index)])
        }
        return ranStr
    }
    
    /// 格式化时间字符串
    static func dateFormatter(_ date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = formatter.string(from: date)
        return dateStr
    }
    
    /// JSON字符串转对象
    func toObject() throws -> Any? {
        let data = self.data(using: .utf8)
        // 容错处理
        guard data != nil else { return nil }
        return try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves)
    }

    /// 版本号比较
    func isHeightVersion(over version: String) -> Bool {
        compare(version, options: .numeric, range: nil, locale: nil) == .orderedDescending
    }

    /// 判断字符串中是否为空,或只包含空字符(空格/换行)
    var isBlank: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// 去除字符串中的空格
    var removeAllSapce: String {
        replacingOccurrences(of: " ", with: "")
    }
}

// 文件夹相关处理
extension String {
    /// 文件大小
    var length: Int64 {
        guard let data = FileManager.default.contents(atPath: self) else { return 0 }
        return Int64(data.count)
    }

    /// 文件夹是否存在
    var isFolderExist: Bool {
        var isDirectory: ObjCBool = false
        return FileManager.default.fileExists(atPath: self, isDirectory: &isDirectory) && isDirectory.boolValue
    }

    /// 文件是否存在
    var isFileExist: Bool {
        FileManager.default.fileExists(atPath: self)
    }

    /// 创建指定目录
    func createFolderPath() {
        try? FileManager.default.createDirectory(atPath: self, withIntermediateDirectories: true, attributes: nil)
    }

    /// 拷贝文件夹
    func copyTo(_ path:String) {
        try? FileManager.default.removeItem(atPath: path)
        try? FileManager.default.copyItem(atPath: self, toPath: path)
    }
    
    /// 移动文件夹
    func moveTo(_ path:String) {
        try? FileManager.default.moveItem(atPath: self, toPath: path)
    }

    /// 删除文件夹
    func removePath() {
        try? FileManager.default.removeItem(atPath: self)
    }
}

// 字符串截取
extension String {
    /// at之前的String
    func format(before at: Int) -> String { (self as NSString).substring(to: at) }
    
    /// at之后的String
    func format(after at: Int) -> String { (self as NSString).substring(from: at) }
    
    /// 区间范围String
    func format(range location: Int, length: Int) -> String {
        (self as NSString).substring(with: NSRange(location: location, length: length))
    }
}
