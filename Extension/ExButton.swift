//
//  ExButton.swift
//  DevHelper
//
//  Created by a51095 on 2021/11/11.
//

extension UIButton {
    /// 逆时针方向🔄
    enum Position { case top, left, bottom, right }
    
    // MARK: 重置图片image与标题title位置(默认间距为0)
    func adjustImageTitlePosition(_ position: Position, spacing: CGFloat = 0 ) {
        self.sizeToFit()
        
        let imageWidth = self.imageView?.image?.size.width
        let imageHeight = self.imageView?.image?.size.height
        
        let labelWidth = self.titleLabel?.frame.size.width
        let labelHeight = self.titleLabel?.frame.size.height
        
        switch position {
        case .top:
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight! - spacing / 2, left: 0, bottom: 0, right: -labelWidth!)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!, bottom: -imageHeight! - spacing / 2, right: 0)
            break
            
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing / 2, bottom: 0, right: 0)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing * 1.5, bottom: 0, right: 0)
            break
            
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight! - spacing / 2, right: -labelWidth!)
            titleEdgeInsets = UIEdgeInsets(top: -imageHeight! - spacing / 2, left: -imageWidth!, bottom: 0, right: 0)
            break
            
        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth! + spacing / 2, bottom: 0, right: -labelWidth! - spacing / 2)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth! - spacing / 2, bottom: 0, right: imageWidth! + spacing / 2)
            break
        }
    }
}
