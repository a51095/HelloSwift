//
//  CCColor.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/15.
//

import UIKit
import Foundation

extension UIColor {
    
    /// 拓展一个APP主色调
    open class var main: UIColor { .hexColor("#FFD700") }
    
    public static func rgb(r: Int, g: Int, b: Int, a: CGFloat = 1) -> UIColor{
        return UIColor(red: r.cgf / 255.0, green: g.cgf / 255.0, blue: b.cgf / 255.0, alpha: a)
    }
    
    private static func hexColor(_ hex: Int, a: CGFloat = 1) -> UIColor {
        let red = (hex >> 16) & 0xFF
        let green = (hex >> 8) & 0xFF
        let blue = hex & 0xFF
        return rgb(r: red, g: green, b: blue, a: a)
    }
    
    public static func hexColor(_ hexString: String, _ alpha: CGFloat = 1) -> UIColor {
        var string = ""
        let lowercaseHexString = hexString.lowercased()
        if lowercaseHexString.hasPrefix("0x") {
            string = lowercaseHexString.replacingOccurrences(of: "0x", with: "")
        } else if hexString.hasPrefix("#") {
            string = hexString.replacingOccurrences(of: "#", with: "")
        } else {
            string = hexString
        }

        if string.count == 3 { // convert hex to 6 digit format if in short format
            var str = ""
            string.forEach { str.append(String(repeating: String($0), count: 2)) }
            string = str
        }
        let hexValue = Int(string, radix: 16) ?? 0
        return hexColor(hexValue, a: alpha)
    }
}
