extension UIImage {
    /// 缩略图(scale默认为1，即返回原图)
    func thumbnail(scale: CGFloat = 1.0) -> UIImage {
        // 容错处理,仅在缩放比例在0~1开区间,重绘缩略图
        guard scale > 0 && scale < 1 else { return self }
        
        var tagSize = size
        tagSize.width = scale * size.width
        tagSize.height = scale * size.height
        
        UIGraphicsBeginImageContext(tagSize)
        self.draw(in: CGRect(x: 0, y: 0, width: tagSize.width, height: tagSize.height))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img ?? self
    }
    
    /// 旋转图片(90代表右旋转↪️，-90代表左旋转↩️)
    func rotate(direction: CGFloat) -> UIImage {
        // 容错处理
        guard let currentContext = UIGraphicsGetCurrentContext(), let cgImage = cgImage else { return self }
        
        let degrees = round(direction / 90) * 90
        let sameOrientationType = degrees.i % 180 == 0
        let radians = .pi * degrees / 180.cgf
        let newSize = sameOrientationType ? size : CGSize(width: size.height, height: size.width)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        currentContext.translateBy(x: newSize.width / 2, y: newSize.height / 2)
        currentContext.rotate(by: radians)
        currentContext.scaleBy(x: 1, y: -1)
        let origin = CGPoint(x: -(size.width / 2), y: -(size.height / 2))
        let rect = CGRect(origin: origin, size: size)
        currentContext.draw(cgImage, in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img ?? self
    }
    
    /// 压缩图片(默认压缩至0.5M)
    func compress(toByte: Int = 512 * 1024) -> Data? {
        autoreleasepool {
            var compression: CGFloat = 1
            guard var data = self.jpegData(compressionQuality: compression) else { return nil}
            
            // 若原图小于限制大小,则直接返回,不做压缩处理;
            if data.count <= toByte { return data }
            
            kPrint("压缩前 == \(data.count) byte")
            var max: CGFloat = 1
            var min: CGFloat = 0
            
            // 减少压缩比例
            if data.count.cgf / toByte.cgf < 1.5 {
                min = 0.8
            } else {
                for _ in 0..<6 {
                    compression = (max + min) / 2
                    data = self.jpegData(compressionQuality: compression)!
                    if data.count.cgf < toByte.cgf * 0.9 {
                        min = compression
                    }else if data.count > toByte {
                        max = compression
                    }else {
                        break
                    }
                }
            }
            
            if data.count < toByte {
                kPrint("压缩后 == \(data.count) byte")
                return data
            }
            
            // 大图重绘后再次压缩
            var resultImage: UIImage = UIImage(data: data)!
            var lastDataLength: Int = 0
            while data.count > toByte, data.count != lastDataLength {
                lastDataLength = data.count
                let ratio: CGFloat = (toByte / data.count).cgf
                let size: CGSize = CGSize(width: resultImage.size.width.i * sqrt(ratio).i,
                                          height: resultImage.size.height.i * sqrt(ratio).i)
                UIGraphicsBeginImageContext(size)
                resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                resultImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                data = resultImage.jpegData(compressionQuality: 1)!
            }
            kPrint("大图片重绘压缩后 == \(data.count) byte")
            return data
        }
    }
        
    /// 渲染GIF图片
    static func gif(_ data: Data) -> ([UIImage]?, TimeInterval) {
        // 从data中读取数据: 将data转成CGImageSource对象
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else { return (nil, 0) }
        let imageCount = CGImageSourceGetCount(imageSource)
        
        // 遍历所有图片
        var images = [UIImage]()
        var totalDuration: TimeInterval = 0
        for i in 0 ..< imageCount {
            // 分解取出,每一帧图片
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
            let image = UIImage(cgImage: cgImage)
            images.append(image)
            
            // 取出gif持续总时长
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) else { continue }
            guard let gifDict = (properties as NSDictionary)[kCGImagePropertyGIFDictionary] as? NSDictionary else { continue }
            guard let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber else { continue }
            totalDuration += frameDuration.doubleValue
        }
        
        return (images,totalDuration)
    }
}

// 滤镜相关
extension UIImage {
    
    /// 重新绘制带滤镜效果的UIImage对象
    private func repaint(_ filter: CIFilter) -> UIImage {
        // 设置输入源
        let inputImg = CIImage(cgImage: self.cgImage!)
        filter.setValue(inputImg, forKey: kCIInputImageKey)
        // 重绘输出源
        guard let outputImg = filter.outputImage else { return self }
        let context = CIContext(options: nil)
        guard let cgImg = context.createCGImage(outputImg, from: outputImg.extent) else { return self }
        return UIImage(cgImage: cgImg, scale: self.scale, orientation: self.imageOrientation)
    }
    
    /// 增亮
    func brightFiler() -> UIImage {
        guard let filter =  CIFilter(name: "CIColorControls") else { return self }
        filter.setValue(0.2, forKey: kCIInputBrightnessKey)
        return repaint(filter)
    }
    
    /// 锐化
    func sharpenFilter() -> UIImage {
        guard let filter =  CIFilter(name: "CISharpenLuminance") else { return self }
        filter.setValue(18, forKey: kCIInputSharpnessKey)
        return repaint(filter)
    }
    
    /// 灰度
    func grayFilter() -> UIImage {
        guard let filter =  CIFilter(name: "CIColorControls") else { return self }
        filter.setValue(0, forKey: kCIInputSaturationKey)
        return repaint(filter)
    }
    
    /// 黑色
    func blackFilter() -> UIImage {
        guard let filter = CIFilter(name: "CIPhotoEffectNoir") else { return self }
        return repaint(filter)
    }
    
    /// 素描
    func sketchFilter() -> UIImage {
        // 去色
        guard let filter = CIFilter(name: "CIPhotoEffectMono") else { return self }
        let ciimage = CIImage(cgImage: self.cgImage!)
        filter.setValue(ciimage, forKey: kCIInputImageKey)
        guard let outputImage = filter.outputImage else { return self }
        // 反转颜色
        var inverImage = outputImage.copy()
        guard let invertFilter = CIFilter(name: "CIColorInvert") else { return self }
        invertFilter.setValue(inverImage, forKey: kCIInputImageKey)
        inverImage = invertFilter.outputImage as Any
        // 高斯模糊
        guard let blurFilter = CIFilter(name: "CIGaussianBlur") else { return self }
        blurFilter.setValue(5, forKey: kCIInputRadiusKey)
        blurFilter.setValue(inverImage, forKey: kCIInputImageKey)
        inverImage = blurFilter.outputImage as Any
        // 混合叠加
        guard let blenFilter = CIFilter(name: "CIColorDodgeBlendMode") else { return self }
        blenFilter.setValue(inverImage, forKey: kCIInputImageKey)
        blenFilter.setValue(outputImage, forKey: kCIInputBackgroundImageKey)
        guard let sketchImage = blenFilter.outputImage else { return self }
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(sketchImage, from: ciimage.extent) else { return self }
        return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
    }
}
