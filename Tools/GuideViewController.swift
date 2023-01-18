//
//  GuideViewController.swift
//  HelloSwift
//
//  Created by well on 2021/9/14.
//

/**
 * GuideViewController:
 * 启动引导视图
 **/

struct GuideConfig {
    /// 资源名称
    fileprivate var resourceName: [String]
    /// 是否展示跳过按钮(默认展示)
    fileprivate var isSkip: Bool
    
    init(resource: [String], skip: Bool = true) {
        isSkip = skip
        resourceName = resource
    }
}

class GuideViewController: BaseViewController, UIScrollViewDelegate {
    
    /// 引导视图配置参数
    private var guideConfig: GuideConfig
    /// 资源图片的个数
    private var displayCount: Int
    /// 引导圆点pageControl
    private var pageControl = UIPageControl()
    
    /// 懒加载skipButton
    private lazy var skipButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.setTitle("跳过", for: .normal)
        button.titleLabel?.font = kRegularFont(16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .hexColor("#000000", 0.8)
        button.addTarget(self, action: #selector(skipButtonDidSeleted), for: .touchUpInside)
        return button
    }()
    
    /// 懒加载startButton
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.setTitle("开始体验", for: .normal)
        button.titleLabel?.font = kRegularFont(16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .hexColor("#000000", 0.8)
        button.addTarget(self, action: #selector(startButtonDidSeleted), for: .touchUpInside)
        return button
    }()
    
    /// 设置状态栏为字体颜色为白色
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - 反初始化器
    deinit { kPrint("GuideViewController deinit~") }
    
    // MARK: 数据初始化
    init(config: GuideConfig) {
        guideConfig = config
        displayCount = config.resourceName.count
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: 视图初始化
    override func setUI() {
        // 非空校验
        guard !guideConfig.resourceName.isEmpty else {
            kAppDelegate.window!!.rootViewController = BaseTabBarController()
            return
        }
        
        func createImageView(imageName: String) -> UIImageView {
            let imgView = UIImageView()
            imgView.image = UIImage(named: imageName)
            imgView.layer.masksToBounds = true
            imgView.contentMode = .scaleAspectFill
            return imgView
        }
        
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentSize = CGSize(width: kScreenWidth * displayCount, height: 0)
        scrollView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        var viewArray = [UIImageView]()
        for name in guideConfig.resourceName {
            let imgView =  createImageView(imageName: name)
            viewArray.append(imgView)
        }
        
        let stackView = UIStackView(arrangedSubviews: viewArray)
        scrollView.addSubview(stackView)
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.frame = CGRect(x: 0, y: 0, width: kScreenWidth * displayCount, height: kScreenHeight)
        
        addPageControl()
        addStartButton()
        
        if guideConfig.isSkip { addSkipButton() }
        
    }
    
    // MARK: 添加跳过按钮skipButton
    private func addSkipButton() {
        view.addSubview(skipButton)
        skipButton.frame = CGRect(x: kScreenWidth - 100, y: kSafeMarginTop(0), width: 70, height: 30)
    }
    
    // MARK: 添加开始按钮startButton
    private func addStartButton() {
        view.addSubview(startButton)
        startButton.frame = CGRect(x: kScreenWidth / 2 - 50, y: kScreenHeight - kScaleHeight(100), width: 100, height: 36)
        hideAnimation()
    }
    
    // MARK: 添加显示圆点pageControl
    private func addPageControl() {
        view.addSubview(pageControl)
        pageControl.hidesForSinglePage = true
        pageControl.numberOfPages = displayCount
        pageControl.currentPageIndicatorTintColor = .random
        pageControl.frame = CGRect(x: 0, y: kScreenHeight - kScaleHeight(100), width: kScreenWidth, height: 30)
    }
    
    func setRootViewController() {
        kAppDelegate.window!!.rootViewController = BaseTabBarController()
        Cache.setString("yes", forKey: AppKey.firstKey)
    }
    
    private func displayAnimation() {
        pageControl.isHidden = true
        startButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.25) {
            self.startButton.transform = .identity
        }
    }
    
    private func hideAnimation() {
        pageControl.isHidden = false
        UIView.animate(withDuration: 0.25) {
            self.startButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
    }
    
    // MARK: scrollView代理方法
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = scrollView.contentOffset.x.i / kScreenWidth
        guard currentIndex != pageControl.currentPage else { return }
        pageControl.currentPage = currentIndex
        (pageControl.currentPage == displayCount - 1) ? displayAnimation() : hideAnimation()
    }
    
    @objc func skipButtonDidSeleted() {
        setRootViewController()
    }
    
    @objc func startButtonDidSeleted() {
        setRootViewController()
    }
}
