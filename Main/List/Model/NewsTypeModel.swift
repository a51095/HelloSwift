//
//  NewsTypeModel.swift
//  HelloSwift
//
//  Created by well on 2024/9/23.
//

import SmartCodable

struct NewsTypeModel: SmartCodable {
    /// 新闻类型标识
    var typeId = String()
    /// 新闻类型名称
    var typeName = String()
}
