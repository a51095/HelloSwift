//
//  MenuModel.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/22.
//

import UIKit

class FormulaModel: CCBaseModel {
    /// 原料名称
    var ylName: String?
    /// 用量
    var ylUnit: String?
}

class stepsModel: CCBaseModel {
    /// 步骤索引
    var orderNum: String?
    /// 步骤图片
    var imgUrl: String?
    /// 步骤内容
    var content: String?
}

class MenuModel: CCBaseModel {
    /// 菜谱名称
    var cpName: String?
    /// 小图url
    var smallImg: String?
    /// 大图url
    var largeImg: String?
    /// 分类信息
    var type: String?
    /// 提示
    var tip: String?
    /// 指导
    var des: String?
    /// 原料/配方
    var yl: [FormulaModel] = []
    /// 步骤
    var steps: [stepsModel] = []
}

class MenuManager {
    static var shared = MenuManager()
    
    var menuDic = [String: [MenuModel]]()
    
    func checkSources(nameKey: String) -> [MenuModel]? {
        var res: [MenuModel]?
        for (key,value) in menuDic {
            if nameKey == key {
                res = value
                break
            }
        }
        return res
    }
    
    func updateMenuDic(nameKey: String, value: [MenuModel]) {
        menuDic.updateValue(value, forKey: nameKey)
    }
}
