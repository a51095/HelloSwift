//
//  CCFixedWidthInteger.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/15.
//

import UIKit
import Foundation

extension FixedWidthInteger {
    /// 整型转Float
    var f: Float {
        return Float(self)
    }
    /// 整型转CGFloat
    var cgf: CGFloat {
        return CGFloat(self)
    }
    /// 整型转Double
    var d: Double {
        return Double(self)
    }
    /// 整型转String
    var str: String {
        return String(format: "\(self)" )
    }
}
