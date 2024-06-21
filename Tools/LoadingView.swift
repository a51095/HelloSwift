//
//  LoadingView.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/16.
//

/**
 * LoadingView
 * Loading加载视图
 * 支持文本自定义,展示时,屏幕可视区域受限,避免二次点击
 **/

final class LoadingView: UIView {
    /// 文本UILabel
    private lazy var messageLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.textColor = .white
        l.textAlignment = .center
        l.adjustsFontSizeToFitWidth = true
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    /// 内容UIView
    private lazy var contentView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 5
        v.backgroundColor = UIColor(white: 0, alpha: 0.5)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    /// 转圈UIActivityIndicatorView
    private lazy var activity: UIActivityIndicatorView = {
        let a = UIActivityIndicatorView()
        a.color = .white
        a.translatesAutoresizingMaskIntoConstraints = false
        return a
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 初始化器
    init(_ message: String, _ style: UIActivityIndicatorView.Style) {
        super.init(frame: .zero)
        
        addSubview(contentView)
        contentView.addSubview(activity)
        
        activity.style = style
        
        if !message.isEmpty {
            // contentView
            contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            contentView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
            contentView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: -40).isActive = true
            contentView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, constant: -200).isActive = true
            
            // activity
            activity.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
            activity.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
            activity.widthAnchor.constraint(equalToConstant: 37).isActive = true
            activity.heightAnchor.constraint(equalToConstant: 37).isActive = true
            
            // messageLabel
            messageLabel.text = message
            contentView.addSubview(messageLabel)
            messageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
            messageLabel.topAnchor.constraint(equalTo: activity.bottomAnchor, constant: 10).isActive = true
            messageLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
            messageLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        } else {
            // contentView
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            contentView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            contentView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            // activity
            activity.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
            activity.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        }
        
        activity.startAnimating()
    }
}

extension UIView {
    /// 展示loading(⚠️⚠️⚠️主线程中调用)
    @MainActor func showLoading(_ message: String = "", _ style: UIActivityIndicatorView.Style = .white) {
        // 若当前视图已加载LoadingView,则先移除后,再添加
        if let lastView = subviews.last as? LoadingView { lastView.removeFromSuperview() }
        
        let loadingView = LoadingView(message, style)
        addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
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
