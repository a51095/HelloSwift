class PhotoGuideCell: UITableViewCell {
    /// 相薄缩略图(默认取第一张)
    private var iconImageView = UIImageView()
    /// 相薄名称
    private var nameLabel = UILabel()
    /// 选中状态提示
    private var statueImageView = UIImageView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initSubview()
    }
    
    /// 子视图初始化
    func initSubview() {
        selectionStyle = .none
        iconImageView.layer.cornerRadius = 6
        iconImageView.layer.masksToBounds = true
        iconImageView.contentMode = .scaleAspectFit
        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.top.left.equalTo(10)
            make.bottom.equalTo(-10)
            make.width.equalTo(88)
        }
        
        nameLabel.font = kRegularFont(16)
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImageView.snp.right).offset(20)
        }
        
        statueImageView.isHidden = true
        statueImageView.image = UIImage(named: "photo_guide_select")
        statueImageView.layer.masksToBounds = true
        statueImageView.contentMode = .scaleAspectFit
        contentView.addSubview(statueImageView)
        statueImageView.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.centerY.equalToSuperview()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        statueImageView.isHidden = !selected
    }
    
    func reloadCell(item: AlbumModel) {
        
        if let title = item.title {
            nameLabel.text = title + "(\(item.fetchResult.count))"
        }
        
        if let first = item.fetchResult.firstObject {
            PHCachingImageManager.default().requestImage(for: first, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: .none) { img, _ in
                self.iconImageView.image = img
            }
        }
    }
}
