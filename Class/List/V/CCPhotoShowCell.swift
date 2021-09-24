//
//  CCPhotoShowCell.swift
//  HelloSwift
//
//  Created by well on 2021/9/18.
//

import UIKit

class CCPhotoShowCell: UICollectionViewCell {
    /// 缩略图
    private var photoImageView = UIImageView()
    /// 选中状态提示
    private var statueButton = UIButton()
    /// 媒体类型描述
    private var typeLabel = UILabel()
    /// 蒙层视图
    private var mantleView = UIView()
    /// 选中状态回调
    public var statueBlock: ((Bool) -> Void)?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 反初始化器
    deinit { print("CCPhotoShowCell deinit~") }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
    }
    
    // MARK: - UI初始化
    private func setUI() {
        contentView.addSubview(photoImageView)
        photoImageView.layer.cornerRadius = 2
        photoImageView.layer.masksToBounds = true
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(mantleView)
        mantleView.isUserInteractionEnabled = false
        mantleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(statueButton)
        statueButton.setImage(R.image.photo_guide_normal(), for: .normal)
        statueButton.setImage(R.image.photo_guide_seleted(), for: .selected)
        statueButton.addTarget(self, action: #selector(statueButtonDidSeleted), for: .touchUpInside)
        statueButton.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.right.equalTo(-10)
        }
        
        contentView.addSubview(typeLabel)
        typeLabel.textColor = .white
        typeLabel.textAlignment = .right
        typeLabel.font = BradleyHandFont(18)
        typeLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.bottom.right.equalToSuperview()
        }
    }
        
    /// 渲染cell内容
    public func configCell(item: PhotoModel) {
        typeLabel.text = item.formatTypeString()
        photoImageView.image = item.image
    }
    
    @objc func statueButtonDidSeleted() {
        statueButton.isSelected =  !statueButton.isSelected
        
        if statueButton.isSelected {
            mantleView.backgroundColor = .hexColor("#ffffff", 0.2)
        }else {
            mantleView.backgroundColor = .clear
        }
    }
}
