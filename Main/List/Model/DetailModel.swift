import SmartCodable

enum ContentType: String, SmartCaseDefaultable {
    case img
    case text
    case video
}

struct DetailModel: SmartCodable {
    /// 新闻内容类型
    var type = ContentType.text
    /// 新闻详情
    var content = String()
    /// 新闻图片
    var imageUrl = String()
    /// 新闻视频
    var videoUrl = [String]()
}
