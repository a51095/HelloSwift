//
//  ListCell.swift
//  HelloSwift
//
//  Created by well on 2023/3/12.
//

import UIKit
import Kingfisher
import Foundation

class ListCell: UITableViewCell {
    /// 新闻预览图
    private var preImageView = UIImageView()
    /// 新闻标题
    private var titleLabel = UILabel()
    /// 新闻发布时间
    private var dateLabel = UILabel()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initSubview()
    }

    /// 子视图初始化
    private func initSubview() {
        selectionStyle = .none
        preImageView.layer.cornerRadius = 6
        preImageView.layer.masksToBounds = true
        preImageView.contentMode = .scaleAspectFill
        contentView.addSubview(preImageView)
        preImageView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
            make.width.equalTo(120)
        }

        dateLabel.font = kRegularFont(16)
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.bottom.equalToSuperview()
        }

        titleLabel.numberOfLines = 0
        titleLabel.font = kMediumFont(16)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.right.equalTo(preImageView.snp.left).offset(-10)
            make.bottom.equalTo(dateLabel.snp.top).offset(-10)
        }

        let lineView = UIView()
        contentView.addSubview(lineView)
        lineView.backgroundColor = .gray
        lineView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
    }

    func reloadCell(item: ListModel) {
        preImageView.kf.indicatorType = .activity
        preImageView.kf.setImage(with: URL(string: item.thumbnail_pic_s), placeholder: UIImage(named: "placeholder_list_cell_img"))
        titleLabel.text = item.title
        dateLabel.text = item.date
    }
}
