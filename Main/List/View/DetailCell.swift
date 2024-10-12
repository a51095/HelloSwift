import UIKit

protocol VideoDelegate: AnyObject {
    func didStartPlaying(in cell: DetailCell)
    func didPausePlaying(in cell: DetailCell)
}

class DetailCell: UITableViewCell {
    
    weak var delegate: VideoDelegate?
    
    private let limitH = kScreenHeight / 2
    
    /// 分割线
    private lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.isHidden = true
        lineView.backgroundColor = .lightGray
        return lineView
    }()
    
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
    
    /// 新闻视频信息
    private lazy var videoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(palyVideo))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    private var player: AVPlayer?
    private lazy var playerLayer: AVPlayerLayer = {
        let playerLayer = AVPlayerLayer(player: nil)
        playerLayer.isHidden = true
        playerLayer.videoGravity = .resizeAspectFill
        return playerLayer
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
        
        contentView.addSubview(videoImageView)
        videoImageView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(200)
            make.top.equalToSuperview().offset(limitH - 200)
            make.bottom.equalToSuperview().offset(-limitH)
        }
        
        videoImageView.layer.addSublayer(playerLayer)
        playerLayer.frame = CGRect(x: -10, y: 0, width: kScreenWidth, height: 200)
        
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
    
    func reloadCell(item: DetailModel) {
        // 移除所有子视图的约束
        contentLabel.snp.removeConstraints()
        pictureImageView.snp.removeConstraints()
        videoImageView.snp.removeConstraints()
        
        // 重置控件状态
        lineView.isHidden = true
        contentLabel.isHidden = true
        pictureImageView.isHidden = true
        playerLayer.isHidden = true
        videoImageView.isHidden = true
        
        switch item.type {
            case .img:
                lineView.isHidden = false
                pictureImageView.isHidden = false
                pictureImageView.kf.setImage(with: URL(string: item.imageUrl), placeholder: UIImage(named: "placeholder"))
                
                // 重新设置pictureImageView的约束
                pictureImageView.snp.remakeConstraints { make in
                    make.top.equalToSuperview().offset(10)
                    make.left.equalToSuperview().offset(10)
                    make.right.equalToSuperview().offset(-10)
                    make.bottom.equalToSuperview().offset(-10)
                }
                
            case .text:
                lineView.isHidden = false
                contentLabel.isHidden = false
                contentLabel.text = item.content
                
                // 重新设置contentLabel的约束
                contentLabel.snp.remakeConstraints { make in
                    make.top.equalToSuperview().offset(10)
                    make.left.equalToSuperview().offset(10)
                    make.right.equalToSuperview().offset(-10)
                    make.bottom.equalToSuperview().offset(-10)
                }
                
            case .video:
                if let videoUrl = item.videoUrl.first, let url = URL(string: videoUrl) {
                    videoImageView.isHidden = false
                    videoImageView.kf.setImage(with: URL(string: item.imageUrl), placeholder: UIImage(named: "placeholder"))
                    player = AVPlayer(url: url)
                    playerLayer.player = player
                    
                    // 重新设置videoImageView的约束
                    videoImageView.snp.remakeConstraints { make in
                        make.left.equalTo(10)
                        make.right.equalTo(-10)
                        make.height.equalTo(200)
                        make.top.equalToSuperview().offset(limitH - 200)
                        make.bottom.equalToSuperview().offset(-limitH)
                    }
                    
                    // 更新playerLayer的frame
                    playerLayer.frame = CGRect(x: -10, y: 0, width: kScreenWidth, height: 200)
                }
        }
    }
    
    @objc func palyVideo() {
        showPlayerLayer()
    }
    
    @objc func showPlayerLayer() {
        videoImageView.snp.remakeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(200)
            make.top.equalToSuperview().offset(limitH - 300)
            make.bottom.equalToSuperview().offset(-limitH)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.playerLayer.isHidden = false
            self.playerLayer.frame = CGRect(x: -10, y: 0, width: kScreenWidth, height: 400)
        } completion: { _ in
            self.player?.play()
            self.delegate?.didStartPlaying(in: self)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        player?.pause()
        player = nil
        playerLayer.player = nil
    }
}
