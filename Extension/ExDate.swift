extension Date {
    /// 时间格式化
    static func format(_ dateFormat: String = "yyyy-MM-dd") -> String  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: Date())
    }
}
