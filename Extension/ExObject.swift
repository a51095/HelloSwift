//
//  ExObject.swift
//  DevHelper
//
//  Created by a51095 on 2021/11/11.
//

extension NSObject {
    /// 类的名称字符串(静态属性)
    static var classString: String {
        NSStringFromClass(classForCoder())
    }
    
    /// 类的名称字符串(实例属性)
    var classString: String {
        NSStringFromClass(classForCoder)
    }
}
