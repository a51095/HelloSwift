//
//  CCImage.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/14.
//

import UIKit
import Foundation

extension UIImage {
    
    // MARK: - 旋转图片,正值为右旋转,负值为左旋转
    func rotate(direction: CGFloat) -> UIImage {
        let degrees = round(direction / 90) * 90
        let sameOrientationType = Int(degrees) % 180 == 0
        let radians = .pi * degrees / CGFloat(180)
        let newSize = sameOrientationType ? size : CGSize(width: size.height, height: size.width)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let ctx = UIGraphicsGetCurrentContext(), let cgImage = cgImage else {
            return self
        }
        
        ctx.translateBy(x: newSize.width / 2, y: newSize.height / 2)
        ctx.rotate(by: radians)
        ctx.scaleBy(x: 1, y: -1)
        let origin = CGPoint(x: -(size.width / 2), y: -(size.height / 2))
        let rect = CGRect(origin: origin, size: size)
        ctx.draw(cgImage, in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image ?? self
    }
    
    // MARK: - 压缩图片
    func compress(toByte : Int = 600 * 1024) -> Data? {
        autoreleasepool {
            let newImage = self
            var compression: CGFloat = 1
            guard var data = newImage.jpegData(compressionQuality: compression) else { return nil}
            
            // 若原图小于限制大小,则直接返回,不做压缩处理;
            if data.count <= toByte { return data }
            
            print("压缩前", data.count, "byte")
            var max: CGFloat = 1
            var min: CGFloat = 0
            
            // 旋转 循环压缩  会糊
            if Float(data.count) / Float(toByte) < 1.2 {
                return data
            }
            // 减少 压缩比例
            if Float(data.count) / Float(toByte) < 1.5 {
                min = 0.8
            } else {
                for _ in 0..<6 {
                    compression = (max + min) / 2
                    data = newImage.jpegData(compressionQuality: compression)!
                    if CGFloat(data.count) < CGFloat(toByte) * 0.9 {
                        min = compression
                    }else if data.count > toByte {
                        max = compression
                    }else {
                        break
                    }
                }
            }
            
            if data.count < toByte {
                print("压缩后", data.count, "byte")
                return data
            }
     
            var resultImage: UIImage = UIImage(data: data)!
            var lastDataLength: Int = 0
            while data.count > toByte, data.count != lastDataLength {
                lastDataLength = data.count
                let ratio: CGFloat = CGFloat(toByte) / CGFloat(data.count)
                let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                        height: Int(resultImage.size.height * sqrt(ratio)))
                UIGraphicsBeginImageContext(size)
                resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                resultImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                data = resultImage.jpegData(compressionQuality: 1)!
            }
            
            print("resize压缩后", data.count, "byte")
            return data
        }
    }
    
    //MARK: - 将View转换为UIImage
    static func viewToImage(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        view.layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    // MARK: - 渲染GIF图片
    static func gif(data: Data) -> ([UIImage]?, TimeInterval) {
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
