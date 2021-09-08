//
//  CCAppURL.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/16.
//

struct CCAppURL {
    /// 幽灵免费api
    static let baseFreeUrl: String = "http://cb.ylapi.cn/cookbook/"
    /// 菜谱大全(幽灵)
    static let queryfreeUrl: String = baseFreeUrl + "query.u"
    /// 菜谱分类(幽灵)
    static let typefreeUrl: String  = baseFreeUrl + "cbtype.u"
    
    /// 网络jpg格式图片
    static let adImageUrl: String  = "https://palmchat.cdn.lianxinapp.com/static/resource/imgs/icon_6.jpg"
    /// 网络gif格式动画图片
    static let adGifUrl: String  = "http://adkx.net/w71qe"
    /// 网络mp4格式短视频
    static let adVideoUrl: String  = "https://v-cdn.zjol.com.cn/280442.mp4"
    /// 测试链接🔗
    static let adLinkUrl: String  = "https://www.baidu.com"
    
}
