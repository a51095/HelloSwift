extension UIColor {
    /// App主色调
    static var main: UIColor { .hexColor("#FF8C00") }
    
    @available(iOS 13.0, *)
    /// 自适应颜色
    static var adaptiveColor: UIColor {
        UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black
    }
    
    /// 随机颜色
    static var random: UIColor {
        rgb(Int.random(in: 0...255), Int.random(in: 0...255), Int.random(in: 0...255))
    }
        
    /// 16进制颜色
    static func hexColor(_ hexString: String, _ alpha: CGFloat = 1) -> UIColor {
        var cleanedString = hexString.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        if cleanedString.hasPrefix("0x") {
            cleanedString.removeFirst(2)
        } else if cleanedString.hasPrefix("#") {
            cleanedString.removeFirst()
        }
        
        if cleanedString.count == 3 {
            cleanedString = cleanedString.map { "\($0)\($0)" }.joined()
        }
        
        guard cleanedString.count == 6, let hexValue = Int(cleanedString, radix: 16) else {
            return UIColor.clear
        }
        
        return hexColor(hexValue, alpha)
    }
    
    private static func rgb(_ red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat = 1) -> UIColor {
        UIColor(red: red.cgf / 255.0, green: green.cgf / 255.0, blue: blue.cgf / 255.0, alpha: alpha)
    }
    
    private static func hexColor(_ hex: Int, _ alpha: CGFloat = 1) -> UIColor {
        let red = (hex >> 16) & 0xFF
        let green = (hex >> 8) & 0xFF
        let blue = hex & 0xFF
        return rgb(red, green, blue, alpha)
    }
}
