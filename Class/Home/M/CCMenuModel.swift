//
//  CCMenuModel.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/22.
//

struct FormulaModel: HandyJSON {
    /// 原料名称
    var ylName: String?
    /// 用量
    var ylUnit: String?
}

struct stepsModel: HandyJSON {
    /// 步骤索引
    var orderNum: String?
    /// 步骤图片
    var imgUrl: String?
    /// 步骤内容
    var content: String?
}

struct CCMenuModel: HandyJSON {
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

class CCMenuManager {
    static var shared = CCMenuManager()
    
    var menuDic = [String: [CCMenuModel]]()
    
    func checkSources(nameKey: String) -> [CCMenuModel]? {
        var res: [CCMenuModel]? = nil
        for (key,value) in menuDic {
            if nameKey == key {
                res = value
                break
            }
        }
        return res
    }
    
    func updateMenuDic(nameKey: String, value: [CCMenuModel]) {
        menuDic.updateValue(value, forKey: nameKey)
    }
}
