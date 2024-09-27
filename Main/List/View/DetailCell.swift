import UIKit

class DetailCell: UITableViewCell {
    /// 新闻文本信息
    private lazy var contentLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.isHidden = true
        return textLabel
    }()
    
    /// 新闻图片信息
    private lazy var pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        return imageView
    }()
    
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
        
        contentLabel.numberOfLines = 0
        contentLabel.font = kRegularFont(16)
        contentView.addSubview(contentLabel)
        
        pictureImageView.contentMode = .scaleAspectFit
        contentView.addSubview(pictureImageView)
        
        let lineView = UIView()
        contentView.addSubview(lineView)
        lineView.backgroundColor = .lightGray
        lineView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
    
    func reloadCell(item: DetailModel) {
        switch item.type {
            case .img:
                contentLabel.isHidden = true
                pictureImageView.isHidden = false
                if let url = item.imageUrl {
                    pictureImageView.kf.setImage(with: URL(string: url), placeholder: UIImage(named: "placeholder"))
                }
                // 移除contentLabel约束
                contentLabel.snp.removeConstraints()
                // 重新计算pictureImageView高度
                pictureImageView.snp.remakeConstraints { (make) in
                    make.edges.equalTo(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
                }
            case .text:
                pictureImageView.isHidden = true
                contentLabel.isHidden = false
                contentLabel.text = item.content
                // 移除pictureImageView约束
                pictureImageView.snp.removeConstraints()
                // 重新计算contentLabel高度
                contentLabel.snp.remakeConstraints { (make) in
                    make.edges.equalTo(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
                }
            case .none: break
        }
    }
}
