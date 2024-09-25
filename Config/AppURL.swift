struct AppURL {
    private init() {}
    /// 必应每日随机图
    static let adImageUrl: String  = "https://bing.img.run/m.php"
    /// 网络gif格式动画图片
    static let adGifUrl: String  = "http://adkx.net/w71qe"
    /// 网络mp4格式短视频
    static let adVideoUrl: String  = "https://v-cdn.zjol.com.cn/280442.mp4"
    /// 测试链接🔗
    static let adLinkUrl: String  = "https://cn.bing.com"
    /// 聚和免费api
    private static let juheUrl: String  = "http://v.juhe.cn/"
    /// 聚合新闻列表
    static let toutiaoUrl: String  = juheUrl + "toutiao/index"
    /// 聚合新闻详情
    static let toutiaoContentUrl: String  = juheUrl + "toutiao/content"
    /// unsplash免费api
    private static let unsplashUrl: String  = "https://api.unsplash.com/"
    /// 图片数组
    static let photosUrl: String  = unsplashUrl + "photos"
    /// roll 新闻 api
    private static let rollUrl: String  = "https://www.mxnzp.com/"
    /// roll 新闻类型
    static let rollTypesUrl: String  = rollUrl + "api/news/types/v2?"
    /// roll 新闻列表
    static let rollListUrl: String  = rollUrl + "api/news/list/v2?"
    /// roll 新闻详情
    static let rollDetailUrl: String  = rollUrl + "api/news/details/v2?"
}
