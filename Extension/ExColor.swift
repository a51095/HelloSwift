//
//  ExColor.swift
//  DevHelper
//
//  Created by a51095 on 2021/11/11.
//

public extension UIColor {
    /// App主色调
    class var main: UIColor { .hexColor("#FFD700") }
    
    /// 随机颜色
    class var random: UIColor {
        rgb(Int(arc4random_uniform(256)), Int(arc4random_uniform(256)), Int(arc4random_uniform(256)))
    }
    
    static func rgb(_ red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat = 1) -> UIColor{
        UIColor(red: red.cgf / 255.0, green: green.cgf / 255.0, blue: blue.cgf / 255.0, alpha: alpha)
    }
    
    private static func hexColor(_ hex: Int, _ alpha: CGFloat = 1) -> UIColor {
        let red = (hex >> 16) & 0xFF
        let green = (hex >> 8) & 0xFF
        let blue = hex & 0xFF
        return rgb(red, green, blue, alpha)
    }
    
    /// 16进制颜色值
    static func hexColor(_ hexString: String, _ alpha: CGFloat = 1) -> UIColor {
        var string = ""
        let lowercaseHexString = hexString.lowercased()
        if lowercaseHexString.hasPrefix("0x") {
            string = lowercaseHexString.replacingOccurrences(of: "0x", with: "")
        } else if hexString.hasPrefix("#") {
            string = hexString.replacingOccurrences(of: "#", with: "")
        } else {
            string = hexString
        }

        if string.count == 3 {
            var str = ""
            string.forEach { str.append(String(repeating: String($0), count: 2)) }
            string = str
        }
        let hexValue = Int(string, radix: 16) ?? 0
        return hexColor(hexValue, alpha)
    }
}
