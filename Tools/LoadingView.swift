//
//  LoadingView.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/16.
//

/**
 * LoadingView
 * Loading加载视图
 * 支持文字显示
 **/

final class LoadingView: UIView {
    /// 懒加载，提示label
    private lazy var messageLabel: UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.font = kRegularFont(16)
        l.textAlignment = .center
        return l
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 反初始化器
    deinit { kPrint("LoadingView deinit") }
    
    // MARK: 初始化器
    init(toast: String) {
        super.init(frame: .zero)
        
        let contentView = UIView()
        contentView.layer.cornerRadius = 5
        contentView.backgroundColor = .hexColor("#000000", 0.5)
        addSubview(contentView)
        
        let activity = UIActivityIndicatorView(style: .white)
        contentView.addSubview(activity)
        
        if !toast.isEmpty {
            // 中间内容视图
            contentView.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.size.equalTo(CGSize(width: 120, height: 100))
            }
            
            // 加载转圈视图
            activity.snp.makeConstraints { (make) in
                make.top.equalTo(16)
                make.centerX.equalToSuperview()
                make.size.equalTo(CGSize(width: 37, height: 37))
            }
            
            // 文字提示视图
            messageLabel.text = toast
            addSubview(messageLabel)
            messageLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(contentView.snp.bottom)
                make.size.equalTo(CGSize(width: 120, height: 36))
            }
        }else {
            // 中间内容视图
            contentView.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.size.equalTo(CGSize(width: 100, height: 100))
            }
            
            // 加载转圈视图
            activity.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
            }
        }
        activity.startAnimating()
    }
}

extension UIView {
    /// 展示loading(⚠️⚠️⚠️主线程中调用)
    @MainActor func showLoading(_ message: String = "") {
        // 若当前视图已加载LoadingView,则直接返回,不再二次添加;
        if let lastView = subviews.last as? LoadingView { lastView.removeFromSuperview() }
        
        let loadingView = LoadingView(toast: message)
        addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    /// 隐藏loading(⚠️⚠️⚠️主线程中调用)
    @MainActor func hideLoading() {
        for item in subviews {
            if item.isKind(of: LoadingView.self) {
                item.removeFromSuperview()
            }
        }
    }
}
