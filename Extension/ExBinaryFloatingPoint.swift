extension BinaryFloatingPoint {
    /// 浮点型转整型
    var i: Int { return Int(self) }
    
    /// 小数点后如果只有0，则取整显示，反之则显示原值
     var cleanZero: String {
        if let i = Int(exactly: self) { return String(i) }
        return String(Double(self))
    }
}
