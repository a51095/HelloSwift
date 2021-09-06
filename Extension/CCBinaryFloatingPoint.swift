//
//  CCBinaryFloatingPoint.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/15.
//

extension BinaryFloatingPoint {
    /// 浮点型转整型
    var i: Int { return Int(self) }
    
    /// 小数点后如果只是0,取整显示;反之,则显示原值;
     var cleanZero : String {
        if let i = Int(exactly: self) { return String(i) }
        return String(Double(self))
    }
}
