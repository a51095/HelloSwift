//
//  ExButton.swift
//  DevHelper
//
//  Created by a51095 on 2021/11/11.
//

extension UIButton {
    enum Position { case top, left, bottom, right }

    func adjustImageTitlePosition(_ position: Position, spacing: CGFloat = 0 ) {
        guard let imageView = self.imageView, let titleLabel = self.titleLabel else { return }

        let imageWidth = imageView.frame.size.width
        let imageHeight = imageView.frame.size.height

        let labelWidth = titleLabel.frame.size.width
        let labelHeight = titleLabel.frame.size.height

        let horizontalSpacing = (imageWidth + labelWidth) / 2
        let verticalSpacing = (imageHeight + labelHeight) / 2

        switch position {
        case .top:
            guard (imageHeight + labelHeight + spacing) < self.frame.height else { return }
            imageEdgeInsets = UIEdgeInsets(top: -verticalSpacing - spacing / 2, left: 0, bottom: 0, right: -horizontalSpacing)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -horizontalSpacing, bottom: -verticalSpacing - spacing / 2, right: 0)

        case .left:
            guard (imageWidth + labelWidth + spacing) < self.frame.width else { return }
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing / 2, bottom: 0, right: spacing / 2)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing / 2, bottom: 0, right: -spacing / 2)

        case .bottom:
            guard (imageHeight + labelHeight + spacing) < self.frame.height else { return }
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -verticalSpacing - spacing / 2, right: -horizontalSpacing)
            titleEdgeInsets = UIEdgeInsets(top: -verticalSpacing - spacing / 2, left: -horizontalSpacing, bottom: 0, right: 0)

        case .right:
            guard (imageWidth + labelWidth + spacing) < self.frame.width else { return }
            imageEdgeInsets = UIEdgeInsets(top: 0, left: horizontalSpacing + spacing / 2, bottom: 0, right: -horizontalSpacing - spacing / 2)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -horizontalSpacing - spacing / 2, bottom: 0, right: horizontalSpacing + spacing / 2)
        }
    }
}
