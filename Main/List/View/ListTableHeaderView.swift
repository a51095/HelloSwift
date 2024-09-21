//
//  ListTableHeaderView.swift
//  HelloSwift
//
//  Created by well on 2024/9/21.
//

import UIKit

class ListTableHeaderView: UIView {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "aspect")
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return imageView
    }()
    var imageViewFrame: CGRect = CGRect.zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageViewFrame = bounds
    }
    
    func scrollViewDidScroll(contentOffsetY: CGFloat) {
        var frame = imageViewFrame
        frame.size.height -= contentOffsetY
        frame.origin.y = contentOffsetY
        imageView.frame = frame
    }
}
