enum ContentType: String {
    case img
    case text
}

struct DetailModel {
    /// 新闻内容类型
    var type: ContentType?
    /// 新闻详情
    var content: String?
    /// 新闻图片
    var imageUrl: String?
}
