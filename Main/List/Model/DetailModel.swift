import SwiftyJSON

struct DetailModel {
    /// 新闻详情
    var content: String?
    /// 预览图1
    var thumbnail_pic_s: String?
    /// 预览图2
    var thumbnail_pic_s02: String?
    /// 预览图3
    var thumbnail_pic_s03: String?

    init(jsonData: JSON) {
        let detail = jsonData["result"]["detail"].dictionaryValue
        self.content = jsonData["result"]["content"].stringValue
        self.thumbnail_pic_s = detail["thumbnail_pic_s"]?.stringValue
        self.thumbnail_pic_s02 = detail["thumbnail_pic_s02"]?.stringValue
        self.thumbnail_pic_s03 = detail["thumbnail_pic_s03"]?.stringValue
    }
}
