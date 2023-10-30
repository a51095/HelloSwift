//
//  ExButton.swift
//  DevHelper
//
//  Created by a51095 on 2021/11/11.
//

extension UIButton {
    enum ImagePosition { case top, right, bottom, left }

    func adjustImageRelativeTitle(_ position: ImagePosition, spacing: CGFloat = 0.0) {
        setTitle(currentTitle, for: .normal)
        setImage(currentImage, for: .normal)
        setTitle(currentTitle, for: .disabled)
        setImage(currentImage, for: .disabled)
        setTitle(currentTitle, for: .selected)
        setImage(currentImage, for: .selected)
        setTitle(currentTitle, for: .highlighted)
        setImage(currentImage, for: .highlighted)

        let imageWidth = imageView?.image?.size.width ?? 0
        let imageHeight = imageView?.image?.size.height ?? 0
        let labelWidth = titleLabel?.text?.size(withAttributes: [.font: titleLabel?.font ?? UIFont.systemFont(ofSize: 0)]).width ?? 0
        let labelHeight = titleLabel?.text?.size(withAttributes: [.font: titleLabel?.font ?? UIFont.systemFont(ofSize: 0)]).height ?? 0

        let imageOffsetX = (imageWidth + labelWidth) / 2 - imageWidth / 2
        let imageOffsetY = imageHeight / 2 + spacing / 2
        let labelOffsetX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2
        let labelOffsetY = labelHeight / 2 + spacing / 2

        let tempWidth = max(labelWidth, imageWidth)
        let changedWidth = labelWidth + imageWidth - tempWidth
        let tempHeight = max(labelHeight, imageHeight)
        let changedHeight = labelHeight + imageHeight + spacing - tempHeight

        switch position {
        case .top:
            imageEdgeInsets = UIEdgeInsets(top: -imageOffsetY, left: imageOffsetX, bottom: imageOffsetY, right: -imageOffsetX)
            titleEdgeInsets = UIEdgeInsets(top: labelOffsetY, left: -labelOffsetX, bottom: -labelOffsetY, right: labelOffsetX)
            contentEdgeInsets = UIEdgeInsets(top: imageOffsetY, left: -changedWidth / 2, bottom: changedHeight-imageOffsetY, right: -changedWidth / 2)
        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth + spacing / 2, bottom: 0, right: -(labelWidth + spacing / 2))
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageWidth + spacing / 2), bottom: 0, right: imageWidth + spacing / 2)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing / 2, bottom:0, right: spacing / 2)
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: imageOffsetY, left: imageOffsetX, bottom: -imageOffsetY, right: -imageOffsetX)
            titleEdgeInsets = UIEdgeInsets(top: -labelOffsetY, left: -labelOffsetX, bottom: labelOffsetY, right: labelOffsetX)
            contentEdgeInsets = UIEdgeInsets(top: changedHeight - imageOffsetY, left: -changedWidth / 2, bottom: imageOffsetY, right: -changedWidth / 2)
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing / 2, bottom: 0, right: spacing / 2)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing / 2, bottom: 0, right: -spacing / 2)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing / 2, bottom: 0, right: spacing / 2)
        }
    }
}
