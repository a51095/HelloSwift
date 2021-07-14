//
//  CCObject.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/14.
//

import Foundation

extension NSObject {
    // MARK: - 获取当前类的名称字符串
    static func classString() -> String {
        return NSStringFromClass(self.classForCoder())
    }
    
    // MARK: - 获取当前对象所属类的名称字符串
    func classString() -> String {
        return NSStringFromClass(self.classForCoder)
    }
}
