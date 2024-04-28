enum PhotoType: String {
    case Gif, Live, Image, Video
}

// 相簿模型
struct AlbumModel {
    /// 相簿名称
    var title: String?
    /// 相簿内容资源
    var  fetchResult: PHFetchResult<PHAsset>
}

// 相簿内容模型
struct PhotoModel {
    /// 资源类型
    var type: PhotoType
    /// 资源图片
    var image: UIImage
    /// 资源asset
    var asset: PHAsset
}
