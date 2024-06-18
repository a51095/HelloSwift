//
//  ToastView.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/15.
//

/**
 * ToastView
 * 吐司弹框视图
 * 支持文本自定义, 显示时长(默认2秒)
 **/

enum ToastType { case none, success, failure }

final class ToastView: UIView {
    private var limitTop: CGFloat = 12
    /// 懒加载icon控件
    private lazy var iconImageView: UIImageView = { UIImageView() }()
    /// 懒加载message控件
    private lazy var messageLabel: UILabel = {
        let message = UILabel()
        message.numberOfLines = 0
        message.textColor = .white
        message.font = kRegularFont(16)
        message.textAlignment = .center
        return message
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 反初始化器
    deinit { kPrint("ToastView deinit") }
    
    /// 初始化器
    init(_ title: String, type: ToastType = .none) {
        super.init(frame: .zero)
        
        layer.cornerRadius = 5
        layer.masksToBounds = true
        backgroundColor = .hexColor("#000000", 0.5)
        
        configureIcon(type)
        configureMessageLabel(title)
    }
    
    private func configureIcon(_ type: ToastType) {
        switch type {
        case .success:
            iconImageView.image = UIImage(named: "toast_success")
        case .failure:
            iconImageView.image = UIImage(named: "toast_fail")
        default: return
        }
        
        limitTop += iconImageView.image!.size.height
        
        self.addSubview(iconImageView)
        
        iconImageView.sizeToFit()
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
    }
    
    private func configureMessageLabel(_ title: String) {
        self.addSubview(messageLabel)
        
        messageLabel.text = title
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: limitTop).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    }
}

extension UIView {
    /// 吐司展示
    func toast(_ message: String, type: ToastType = .none, delay: TimeInterval = 2) {
        // 容错处理,若message字段无内容,则直接返回
        guard !message.isEmpty else { return }
        // 若当前视图已加载ToastView,则移除后再添加
        if let lastView = subviews.last as? ToastView { lastView.removeFromSuperview() }
        
        let toastView = ToastView(message, type: type)
        addSubview(toastView)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        toastView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        toastView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        toastView.widthAnchor.constraint(greaterThanOrEqualToConstant: 110).isActive = true
        toastView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: -40).isActive = true
        toastView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, constant: -200).isActive = true
        
        UIView.animate(withDuration: 0.25, delay: delay, options: .curveEaseInOut) {
            toastView.alpha = 0
        } completion: { _ in
            toastView.removeFromSuperview()
        }
    }
}
