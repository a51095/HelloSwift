class ImageCacheManager {
    
    static let shared = ImageCacheManager()
    
    private let imageManager: PHCachingImageManager
    private var targetSize: CGSize
    private var contentMode: PHImageContentMode
    private var options: PHImageRequestOptions
    
    private init() {
        imageManager = PHCachingImageManager()
        targetSize = CGSize(width: 512, height: 512)
        contentMode = .aspectFill
        options = PHImageRequestOptions()
        options.isSynchronous = false
        options.resizeMode = .exact
        options.deliveryMode = .highQualityFormat
    }
    
    func requestImage(for asset: PHAsset, completion: @escaping (UIImage?, [AnyHashable: Any]?) -> Void) {
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: contentMode, options: options) { (image, info) in
            completion(image, info)
        }
    }
    
    func preloadImages(for assets: [PHAsset]) {
        imageManager.startCachingImages(for: assets, targetSize: targetSize, contentMode: contentMode, options: options)
    }
    
    func clearCacheForAllAssets() {
        imageManager.stopCachingImagesForAllAssets()
    }
}
