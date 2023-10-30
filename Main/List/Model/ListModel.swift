//
//  ListModel.swift
//  HelloSwift
//
//  Created by well on 2023/3/12.
//

import Foundation
import HandyJSON

struct ListModel: HandyJSON {
    /// 标题
    var title: String?
    /// 发布日期
    var date: String?
    /// 新闻id
    var uniquekey: String?
    /// 预览图1
    var thumbnail_pic_s: String?
    /// 预览图2
    var thumbnail_pic_s02: String?
    /// 预览图3
    var thumbnail_pic_s03: String?
}
