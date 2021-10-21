//
//  CCAdViewController.swift
//  HelloSwift
//
//  Created by well on 2021/9/6.
//

/**
 * CCAdViewController:
 * 启动广告引导视图
 * 支持本地资源、网络资源
 * 支持image,gif,video多种格式
 **/

public enum CCAdType { case adImage, adGif, adVideo }
struct CCAdConfig {
    /// 广告类型
    fileprivate var adType: CCAdType
    /// 跳转链接
    fileprivate var linkUrl: String
    /// 资源名称
    fileprivate var resourceName: String
    /// 是否展示跳过按钮(默认展示)
    fileprivate var isSkip: Bool
    /// 是否展示静音按钮(默认展示,仅video类型)
    fileprivate var isMute: Bool
    /// 广告动画时长(默认10秒)
    fileprivate var adDuration: TimeInterval
    
    init(type: CCAdType, name: String, url: String, skip: Bool = true, mute: Bool = true, duration: TimeInterval = 10) {
        isMute = mute
        isSkip = skip
        adType = type
        linkUrl = url
        resourceName = name
        adDuration = duration
    }
}

class CCAdViewController: CCViewController, CCCountDownManagerProtocol {
    
    /// 广告视图配置参数
    private var adConfig: CCAdConfig
    /// 广告视图播放数据源
    private var adAVPlayerItem: AVPlayerItem?
    /// 广告视图消失时回调处理
    public var dismissBlock: os_block_t?
    
    /// 懒加载muteButton
    private lazy var muteButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.ad_mute(), for: .selected)
        button.setImage(R.image.ad_restore(), for: .normal)
        button.addTarget(self, action: #selector(muteButtonDidSeleted), for: .touchUpInside)
        return button
    }()
    
    /// 懒加载skipButton
    private lazy var skipButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.titleLabel?.font = RegularFont(14)
        button.backgroundColor = .hexColor("#000000", 0.5)
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
    
    // MARK: - 反初始化器
    deinit { removeAdAVPlayerItemObserver(); print("CCAdViewController deinit~") }
    
    // MARK: - 初始化器
    init(config: CCAdConfig) {
        adConfig = config
        super.init(nibName: nil, bundle: nil)
    }
    
    /// 添加adAVPlayerItem观察者
    private func addAdAVPlayerItemObserver() {
        adAVPlayerItem?.addObserver(self,forKeyPath: "status", options: .new, context: nil)
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
    
    override func setUI() {
        // 添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(adViewDidSeleted))
        view.addGestureRecognizer(tap)
        
        switch adConfig.adType {
        case .adImage, .adGif: addAdImageView(); break
        case .adVideo: addAdPlayerController(); break
        }
        
        if adConfig.isSkip && adConfig.adType != .adVideo { addSkipButton() }
        
        // 配置显示参数
        configDisPlayParameter()
    }
    
    /// 添加广告muteButton
    func addMuteButton() {
        if adConfig.isMute {
            view.addSubview(muteButton)
            muteButton.snp.makeConstraints { make in
                make.left.equalTo(kAdaptedWidth(36))
                make.top.equalTo(kSafeMarginTop(0))
            }
        }
    }
    
    /// 添加广告skipButton
    func addSkipButton() {
        view.addSubview(skipButton)
        skipButton.snp.makeConstraints { make in
            make.right.equalTo(kAdaptedWidth(-36))
            make.top.equalTo(kSafeMarginTop(0))
            make.size.equalTo(CGSize(width: 70, height: 30))
        }
        
        let startTime = Int(CACurrentMediaTime())
        CCCountDownManager.shared.deletage = self
        CCCountDownManager.shared.run(start: startTime, end: startTime + adConfig.adDuration.i)
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
    func configDisPlayParameter() {
        switch adConfig.adType {
        case .adImage: loadImage(); break
        case .adGif: loadGif(); break
        case .adVideo: loadVideo(); break
        }
    }
    
    /// 加载广告(image)
    private func loadImage() {
        // 非空校验
        guard !adConfig.resourceName.isEmpty else { return }
        
        // 网络资源(image)
        if adConfig.resourceName.hasPrefix("http") {
            // 移除后缀名
            let objString = NSString(string: adConfig.resourceName).deletingPathExtension
            // 不带后缀名的最后一项
            let componentString = NSString(string: objString).lastPathComponent
            // 格式化储存路径
            let adImageTemp = kAppCachesPath + "/" + componentString + ".jpg"
            
            // 无缓存,则获取网络数据后展示
            if !adImageTemp.fileExist() {
                let imgUrl = URL(string: adConfig.resourceName)
                let data = try? Data(contentsOf: imgUrl!)
                
                if let imgData = data {
                    adImageView.image = UIImage(data: imgData)
                    updateAdImage(imgData, adImageTemp)
                }else {
                    // 容错处理,没值则直接移除广告视图,执行后续流程
                    dismiss()
                }
            }else {
                // 有缓存,则直接从缓存读取展示
                let imgUrl = URL(fileURLWithPath: adImageTemp)
                let imgData = try? Data(contentsOf: imgUrl)
                adImageView.image = UIImage(data: imgData!)
            }
        }else {
            // 本地资源(image)
            adImageView.image = UIImage(named: adConfig.resourceName)
        }
    }
    
    /// 加载广告(gif)
    private func loadGif() {
        // 非空校验
        guard !adConfig.resourceName.isEmpty else { return }
        
        // 网络资源(gif)
        if adConfig.resourceName.hasPrefix("http") {
            // 移除后缀名
            let objString = NSString(string: adConfig.resourceName).deletingPathExtension
            // 不带后缀名的最后一项
            let componentString = NSString(string: objString).lastPathComponent
            // 格式化储存路径
            let adGifTemp = kAppCachesPath + "/" + componentString + ".gif"
            
            // 无缓存,则获取网络数据后展示
            if !adGifTemp.fileExist() {
                let imgUrl = URL(string: adConfig.resourceName)
                let data = try? Data(contentsOf: imgUrl!)
                
                if let gifData = data {
                    let gifArray = UIImage.gif(data: gifData)
                    adImageView.animationImages = gifArray.0
                    adImageView.animationDuration = gifArray.1
                    adImageView.startAnimating()
                    updateAdGif(gifData, adGifTemp)
                }else {
                    // 容错处理,没值则直接移除广告视图,执行后续流程
                    dismiss()
                }
            }else {
                // 有缓存,则直接从缓存读取展示
                let gifUrl = URL(fileURLWithPath: adGifTemp)
                let gifData = try? Data(contentsOf: gifUrl)
                let gifArray = UIImage.gif(data: gifData!)
                adImageView.animationImages = gifArray.0
                adImageView.animationDuration = gifArray.1
                adImageView.startAnimating()
            }
        }else {
            // 本地资源(gif)
            let filePath = Bundle.main.path(forResource: adConfig.resourceName, ofType: "gif")!
            let gifUrl = URL(fileURLWithPath: filePath)
            let gifData = try? Data(contentsOf: gifUrl)
            let gifArray = UIImage.gif(data: gifData!)
            adImageView.animationImages = gifArray.0
            adImageView.animationDuration = gifArray.1
            adImageView.startAnimating()
        }
    }
    
    /// 加载广告(video)
    private func loadVideo() {
        // 非空校验
        guard !adConfig.resourceName.isEmpty else { return }
        
        // 网络资源(video)
        if adConfig.resourceName.hasPrefix("http") {
            // 移除后缀名
            let objString = NSString(string: adConfig.resourceName).deletingPathExtension
            // 不带后缀名的最后一项
            let componentString = NSString(string: objString).lastPathComponent
            // 格式化储存路径
            let adVideoTemp = kAppCachesPath + "/" + componentString + ".mp4"
            
            // 无缓存,则获取网络数据后展示
            if !adVideoTemp.fileExist() {
                let videoUrl = URL(string: adConfig.resourceName)!
                let data = try? Data(contentsOf: videoUrl)
                if let videoData = data {
                    adAVPlayerItem = AVPlayerItem(url: videoUrl)
                    let adAVPlayer = AVPlayer(playerItem: adAVPlayerItem)
                    adPlayerController.player = adAVPlayer
                    updateAdVideo(videoData, adVideoTemp)
                }else {
                    // 容错处理,没值则直接移除广告视图,执行后续流程
                    dismiss()
                }
            }else {
                // 有缓存,则直接从缓存读取展示
                let videoUrl = URL(fileURLWithPath: adVideoTemp)
                adAVPlayerItem = AVPlayerItem(url: videoUrl)
                let adAVPlayer = AVPlayer(playerItem: adAVPlayerItem)
                adPlayerController.player = adAVPlayer
            }
        }else {
            // 本地资源(video)
            let filePath = Bundle.main.path(forResource: adConfig.resourceName, ofType: "mp4")
            let videoUrl = URL(fileURLWithPath: filePath!)
            adAVPlayerItem = AVPlayerItem(url: videoUrl)
            let adAVPlayer = AVPlayer(playerItem: adAVPlayerItem)
            adPlayerController.player = adAVPlayer
        }
        addAdAVPlayerItemObserver()
    }
    
    /// 更新广告资源(image)
    public func updateAdImage(_ imageData: Data, _ imageTempPath: String)  {
        DispatchQueue.global().async {
            try? imageData.write(to: URL(fileURLWithPath: imageTempPath), options: .atomic)
        }
    }
    
    /// 更新广告资源(gif)
    public func updateAdGif(_ gifData: Data, _ gifTempPath: String)  {
        DispatchQueue.global().async {
            try? gifData.write(to: URL(fileURLWithPath: gifTempPath), options: .atomic)
        }
    }
    
    /// 更新广告资源(video)
    public func updateAdVideo(_ videoData: Data, _ videoTempPath: String)  {
        DispatchQueue.global().async {
            try? videoData.write(to: URL(fileURLWithPath: videoTempPath), options: .atomic)
        }
    }
    
    /// 移除广告视图
    private func dismiss() {
        UIView.animate(withDuration: 0.25) {
            if self.adConfig.isSkip {
                CCCountDownManager.shared.cannel()
                self.skipButton.removeFromSuperview()
            }
            
            if self.adConfig.adType == .adVideo {
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
    
    /// 跳过事件
    @objc private func skipButtonDidSeleted() { dismiss() }
    
    /// 静音事件
    @objc private func muteButtonDidSeleted() {
        muteButton.isSelected = !muteButton.isSelected
        adPlayerController.player?.isMuted = muteButton.isSelected
    }
    
    /// 广告连接
    @objc private func adViewDidSeleted() {
        dismiss()
        let url = URL(string: adConfig.linkUrl)
        guard (url != nil) else { return }
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
    
    /// CCCountDownManageProtocol代理方法
    func refreshTime(result: [String]) {
        let timeStr = result.last!
        if timeStr == "00" { dismiss(); return }
        
        self.skipButton.setTitle("跳过(\(timeStr)"+"s)", for: .normal)
    }
}
