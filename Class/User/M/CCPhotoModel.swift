//
//  CCPhotoGuideModel.swift
//  HelloSwift
//
//  Created by well on 2021/9/18.
//
import UIKit
import Photos

enum PhotoType {
    case Image, Gif, Live, Video
}

// 相簿模型
struct  AlbumModel  {
    /// 相簿名称
    var title: String?
    /// 相簿内容资源
    var  fetchResult: PHFetchResult<PHAsset>
     
    init(title: String?, fetchResult: PHFetchResult<PHAsset>){
        self.title = title
        self.fetchResult = fetchResult
    }
}

// 相簿内容模型
struct  PhotoModel  {
    /// 资源类型
    var type: PhotoType
    /// 资源图片
    var image: UIImage
    /// 资源asset
    var asset: PHAsset
     
    init(type: PhotoType, image: UIImage, asset: PHAsset){
        self.type = type
        self.image = image
        self.asset = asset
    }
}
