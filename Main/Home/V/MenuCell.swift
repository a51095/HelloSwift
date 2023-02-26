class MenuCell: UITableViewCell {
    /// 菜谱缩略图(小图)
    private var iconImageView = UIImageView()
    /// 菜谱名称
    private var nameLabel = UILabel()
    /// 菜谱提示描述
    private var tipsLabel = UILabel()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUI()
    }
    
    // MARK: - UI初始化
    func setUI() {
        selectionStyle = .none
        iconImageView.layer.cornerRadius = 6
        iconImageView.layer.masksToBounds = true
        iconImageView.contentMode = .scaleAspectFill
        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.top.left.equalTo(20)
            make.bottom.equalTo(-20)
            make.width.equalTo(120)
        }
        
        nameLabel.font = kRegularFont(16)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.height.equalTo(36)
            make.left.equalTo(iconImageView.snp.right).offset(20)
        }
        
        tipsLabel.textColor = .gray
        tipsLabel.numberOfLines = 0
        tipsLabel.font = kRegularFont(14)
        contentView.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.equalTo(nameLabel)
            make.right.bottom.equalTo(-20)
        }
    }
    
    func reloadCell(item: MenuModel) {
        iconImageView.kf.setImage(with: URL(string: item.smallImg!))
        nameLabel.text = item.cpName
        tipsLabel.text = item.tip
    }
}
