import SmartCodable

enum ContentType: String, SmartCaseDefaultable {
    case img
    case text
}

struct DetailModel: SmartCodable {
    /// 新闻内容类型
    var type = ContentType.text
    /// 新闻详情
    var content = String()
    /// 新闻图片
    var imageUrl = String()
}
