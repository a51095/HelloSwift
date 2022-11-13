extension FixedWidthInteger {
    /// 整型转Float
    var f: Float { Float(self) }
    
    /// 整型转CGFloat
    var cgf: CGFloat { CGFloat(self) }
    
    /// 整型转Double
    var d: Double { Double(self) }
    
    /// 整型转String
    var str: String { String(format: "\(self)" ) }
}
