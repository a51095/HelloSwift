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
        
        contentView.addSubview(statueButton)
        statueButton.setImage(R.image.photo_guide_normal(), for: .normal)
        statueButton.setImage(R.image.photo_guide_seleted(), for: .selected)
        statueButton.addTarget(self, action: #selector(statueButtonDidSeleted), for: .touchUpInside)
        statueButton.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.right.equalTo(-10)
        }
    }
    
    // MARK: - 监听用户点击index,继而改变状态
    override var isSelected: Bool {
        willSet {
            
        }
    }
    
    /// 渲染cell内容
    public func configCell(item: PhotoModel) {
        photoImageView.image = item.image
    }
    
    @objc func statueButtonDidSeleted() {
        statueButton.isSelected =  !statueButton.isSelected
    }
}
