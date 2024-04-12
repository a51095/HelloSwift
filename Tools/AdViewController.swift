//
//  AdViewController.swift
//  HelloSwift
//
//  Created by well on 2021/9/6.
//

/**
 * AdViewController:
 * 启动广告引导视图
 * 支持本地资源、网络资源
 * 支持image,gif,video多种格式
 **/
import Kingfisher

enum AdType { case image, gif, video }
struct AdConfig {
    /// 广告类型
    fileprivate var type: AdType
    /// 本地资源名称
    fileprivate var localResource: String? = nil
    /// 远端资源URL
    fileprivate var netUrl: String? = nil
    /// 跳转链接URL
    fileprivate var linkUrl: String? = nil
    /// 是否展示跳过按钮(默认展示)
    fileprivate var isSkip: Bool = true
    /// 是否展示静音按钮(默认展示,仅video类型)
    fileprivate var isMute: Bool = true
    /// 广告动画时长(默认10秒)
    fileprivate var duration: TimeInterval = 10
    /// 是否使用本地资源
    fileprivate var isLocal: Bool {
        localResource != nil
    }

    init(type: AdType, localResource: String? = nil, netUrl: String? = nil, linkUrl: String? = nil, isSkip: Bool = true, isMute: Bool = true, duration: TimeInterval = 10) {
        guard localResource != nil || netUrl != nil else {
            fatalError("Either 'localResource' for local resource or 'netUrl' for remote resource must be provided.")
        }
        self.type = type
        self.localResource = localResource
        self.netUrl = netUrl
        self.linkUrl = linkUrl
        self.isSkip = isSkip
        self.isMute = isMute
        self.duration = duration
    }
}

class AdViewController: BaseViewController, CountDownProtocol {
    /// 广告视图配置参数
    private var adConfig: AdConfig
    /// 广告视图播放数据源
    private var adAVPlayerItem: AVPlayerItem?
    /// 广告视图消失时回调处理
    var dismissBlock: os_block_t?

    /// 懒加载muteButton
    private lazy var muteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ad_mute"), for: .selected)
        button.setImage(UIImage(named: "ad_restore"), for: .normal)
        button.addTarget(self, action: #selector(muteButtonDidSeleted), for: .touchUpInside)
        return button
    }()

    /// 懒加载skipButton
    private lazy var skipButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.backgroundColor = .hexColor("#000000", 0.5)
        button.titleLabel?.font = UIFont(name: "Arial", size: 16.0)
        button.addTarget(self, action: #selector(skipButtonDidSeleted), for: .touchUpInside)
        return button
    }()

    /// 懒加载adImageView
    private lazy var adImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    /// 懒加载adPlayerController
    private lazy var adPlayerController: AVPlayerViewController = {
        let player = AVPlayerViewController()
        player.showsPlaybackControls = false
        player.videoGravity = .resizeAspectFill
        return player
    }()

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    /// 反初始化器
    deinit { removeAdAVPlayerItemObserver(); kPrint("AdViewController deinit") }

    /// 初始化器
    init(config: AdConfig) {
        adConfig = config
        super.init(nibName: nil, bundle: nil)
    }

    /// 添加adAVPlayerItem观察者
    private func addAdAVPlayerItemObserver() {
        adAVPlayerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: .new, context: nil)
    }

    /// 移除adAVPlayerItem观察者
    private func removeAdAVPlayerItemObserver() {
        adAVPlayerItem?.removeObserver(self, forKeyPath: "status", context: nil)
    }

    /// 处理adAVPlayerItem观察者
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let object = object as? AVPlayerItem  else { return }
        guard let keyPath = keyPath else { return }

        if keyPath == "status" {
            if object.status == .readyToPlay {
                // 待视频准备就绪后,添加静音按钮
                if adConfig.isMute { addMuteButton() }
                // 待视频准备就绪后,添加跳过按钮,且开始倒计时
                if adConfig.isSkip { addSkipButton() }
                // 资源准备就绪后,开始播放视频
                adPlayerController.player?.play()
            } else {
                // 容错处理,资源准备失败,则直接移除广告视图,执行后续流程
                dismiss()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSubview()
    }

    override func initSubview() {
        // 添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(adViewDidSeleted))
        view.addGestureRecognizer(tap)

        switch adConfig.type {
        case .image, .gif: addAdImageView(); break
        case .video: addAdPlayerController(); break
        }

        // 配置显示参数
        config()
    }

    /// 添加广告muteButton
    func addMuteButton() {
        if adConfig.isMute {
            view.addSubview(muteButton)
            muteButton.snp.makeConstraints { make in
                make.left.equalTo(kScaleWidth(36))
                make.top.equalTo(kSafeMarginTop(0))
            }
        }
    }

    /// 添加广告skipButton
    func addSkipButton() {
        view.addSubview(skipButton)
        skipButton.snp.makeConstraints { make in
            make.right.equalTo(kScaleWidth(-10))
            make.top.equalTo(kSafeMarginTop(10))
            make.size.equalTo(CGSize(width: 80, height: 36))
        }

        let startTime = Int(CACurrentMediaTime())
        CountDownManager.shared.deletage = self
        CountDownManager.shared.run(start: startTime, end: startTime + adConfig.duration.i)
    }

    /// 添加广告adImageView
    func addAdImageView() {
        view.addSubview(adImageView)
        adImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    /// 添加广告adPlayerController
    func addAdPlayerController() {
        view.addSubview(adPlayerController.view)
        adPlayerController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    /// 配置广告相关参数
    func config() {
        switch adConfig.type {
        case .image: loadImage(); break
        case .gif: loadGif(); break
        case .video: loadVideo(); break
        }
    }

    /// 加载广告(image)
    private func loadImage() {
        if adConfig.isSkip && adConfig.type != .video { addSkipButton() }
        if adConfig.isLocal {
            // 本地资源(image)
            adImageView.image = UIImage(named: adConfig.localResource!)

        } else {
            // 网络资源(image)
            let imgUrl = URL(string: adConfig.netUrl!)
            guard imgUrl != nil else { return }
            let imageResource = KF.ImageResource(downloadURL: imgUrl!, cacheKey: Date().format())
            adImageView.contentMode = .scaleAspectFill
            adImageView.kf.indicatorType = .activity
            adImageView.kf.setImage(with: imageResource, placeholder: UIImage(named: "user_guide04"))
        }
    }

    /// 加载广告(gif)
    private func loadGif() {
        // 本地资源(gif)
        if adConfig.isLocal {
            let filePath = Bundle.main.path(forResource: adConfig.localResource!, ofType: "gif")!
            let gifUrl = URL(fileURLWithPath: filePath)
            if let gifData = try? Data(contentsOf: gifUrl) {
                let gifArray = UIImage.gif(gifData)
                adImageView.animationImages = gifArray.0
                adImageView.animationDuration = gifArray.1
                adImageView.startAnimating()
            }
        } else {
            // 网络资源(gif)
            // 移除后缀名
            let objString = NSString(string: adConfig.netUrl!).deletingPathExtension
            // 不带后缀名的最后一项
            let componentString = NSString(string: objString).lastPathComponent
            // 格式化储存路径
            let adGifTemp = kAppCachesPath + "/" + Date().format() + componentString + ".gif"

            // 无缓存,则获取网络数据后展示
            if !adGifTemp.isFileExist {
                let imgUrl = URL(string: adConfig.netUrl!)
                if let gifData = try? Data(contentsOf: imgUrl!) {
                    let gifArray = UIImage.gif(gifData)
                    adImageView.animationImages = gifArray.0
                    adImageView.animationDuration = gifArray.1
                    adImageView.startAnimating()
                    updateAdGif(gifData, adGifTemp)
                } else {
                    // 容错处理,没值则直接移除广告视图,执行后续流程
                    dismiss()
                }
            } else {
                // 有缓存,则直接从缓存读取展示
                let gifUrl = URL(fileURLWithPath: adGifTemp)
                if let gifData = try? Data(contentsOf: gifUrl) {
                    let gifArray = UIImage.gif(gifData)
                    adImageView.animationImages = gifArray.0
                    adImageView.animationDuration = gifArray.1
                    adImageView.startAnimating()
                }
            }
        }
    }

    /// 加载广告(video)
    private func loadVideo() {
        // 本地资源(video)
        if adConfig.isLocal {
            let filePath = Bundle.main.path(forResource: adConfig.localResource, ofType: "mp4")
            let videoUrl = URL(fileURLWithPath: filePath!)
            adAVPlayerItem = AVPlayerItem(url: videoUrl)
            let adAVPlayer = AVPlayer(playerItem: adAVPlayerItem)
            adPlayerController.player = adAVPlayer
        } else {
            // 网络资源(video)
            // 移除后缀名
            let objString = NSString(string: adConfig.netUrl!).deletingPathExtension
            // 不带后缀名的最后一项
            let componentString = NSString(string: objString).lastPathComponent
            // 格式化储存路径
            let adVideoTemp = kAppCachesPath + "/" + Date().format() + componentString + ".mp4"

            // 无缓存,则获取网络数据后展示
            if !adVideoTemp.isFileExist {
                let videoUrl = URL(string: adConfig.netUrl!)!
                if let videoData = try? Data(contentsOf: videoUrl) {
                    adAVPlayerItem = AVPlayerItem(url: videoUrl)
                    let adAVPlayer = AVPlayer(playerItem: adAVPlayerItem)
                    adPlayerController.player = adAVPlayer
                    updateAdVideo(videoData, adVideoTemp)
                } else {
                    // 容错处理,没值则直接移除广告视图,执行后续流程
                    dismiss()
                }
            } else {
                // 有缓存,则直接从缓存读取展示
                let videoUrl = URL(fileURLWithPath: adVideoTemp)
                adAVPlayerItem = AVPlayerItem(url: videoUrl)
                let adAVPlayer = AVPlayer(playerItem: adAVPlayerItem)
                adPlayerController.player = adAVPlayer
            }
        }
        addAdAVPlayerItemObserver()
    }

    /// 更新广告资源(image)
    func updateAdImage(_ imageData: Data, _ imageTempPath: String)  {
        DispatchQueue.global().async {
            try? imageData.write(to: URL(fileURLWithPath: imageTempPath), options: .atomic)
        }
    }

    /// 更新广告资源(gif)
    func updateAdGif(_ gifData: Data, _ gifTempPath: String)  {
        DispatchQueue.global().async {
            try? gifData.write(to: URL(fileURLWithPath: gifTempPath), options: .atomic)
        }
    }

    /// 更新广告资源(video)
    func updateAdVideo(_ videoData: Data, _ videoTempPath: String)  {
        DispatchQueue.global().async {
            try? videoData.write(to: URL(fileURLWithPath: videoTempPath), options: .atomic)
        }
    }

    /// 移除广告视图
    private func dismiss() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                if self.adConfig.isSkip {
                    CountDownManager.shared.stop()
                    self.skipButton.removeFromSuperview()
                }

                if self.adConfig.type == .video {
                    self.muteButton.removeFromSuperview()
                    self.adPlayerController.player?.isMuted = true
                    self.adPlayerController.player?.pause()
                    self.adPlayerController.view.alpha = 0
                } else {
                    self.adImageView.stopAnimating()
                    self.adImageView.alpha = 0
                }

            } completion: { _ in
                self.dismissBlock?()
            }
        }
    }

    /// 跳过事件
    @objc private func skipButtonDidSeleted() { dismiss() }

    /// 静音事件
    @objc private func muteButtonDidSeleted() {
        muteButton.isSelected = !muteButton.isSelected
        adPlayerController.player?.isMuted = muteButton.isSelected
    }

    /// 广告连接
    @objc private func adViewDidSeleted() {
        // 容错处理
        guard adConfig.linkUrl != nil else { return }
        dismiss()
        let url = URL(string: adConfig.linkUrl!)
        guard (url != nil) else { return }
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }

    /// CountDownProtocol代理方法
    func refreshTime(result: [String]) {
        let timeStr = result.last!
        if timeStr == "00" { dismiss(); return }
        self.skipButton.setTitle("\(kLocalization.commonSkip)(\(timeStr)"+"s)", for: .normal)
    }
}
