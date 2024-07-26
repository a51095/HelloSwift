import SwiftyJSON

struct DataModel {
    var data: [JSON]
    init(jsonData: JSON) {
        self.data = jsonData["result"]["data"].arrayValue
    }
}

struct ListModel {
    /// 标题
    var title: String
    /// 发布日期
    var date: String    
    /// 新闻ID
    var uniquekey: String
    /// 预览图
    var thumbnail_pic_s: String

    init(jsonData: JSON) {
        self.title = jsonData["title"].stringValue
        self.date = jsonData["date"].stringValue.before(16)
        self.uniquekey = jsonData["uniquekey"].stringValue
        self.thumbnail_pic_s = jsonData["thumbnail_pic_s"].stringValue
    }
}
