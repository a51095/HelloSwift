//
//  CCToastView.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/15.
//

enum ToastType {
    case nore, success, failure
}

final class CCToastView: UIView {
    var limitTop: CGFloat = 20
    /// 懒加载icon控件对象
    private lazy var iconImageView: UIImageView = { UIImageView() }()
    /// 懒加载message控件对象
    private lazy var messageLabel: UILabel = {
        let message = UILabel()
        message.numberOfLines = 0
        message.textColor = .white
        message.font = RegularFont(16)
        message.textAlignment = .center
        return message
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 反初始化器
    deinit { print("CCToastView deinit~") }
    
    // MARK: - 初始化器
    init(_ title: String, type: ToastType = .nore) {
        super.init(frame: .zero)
        
        layer.cornerRadius = 5
        layer.masksToBounds = true
        backgroundColor = .hexColor("#000000", 0.5)
        
        if type != .nore {
            if type == .success {
                iconImageView.image = UIImage(named: "toast_success")
            }else {
                iconImageView.image = UIImage(named: "toast_fail")
            }
            
            limitTop += iconImageView.image!.size.height
            
            self.addSubview(iconImageView)
            iconImageView.snp.makeConstraints { (make) in
                make.centerX.equalTo(self)
                make.top.equalTo(self).offset(16)
            }
        }
        
        messageLabel.text = title
        self.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: limitTop, left: 12, bottom: 20, right: 12))
        }
    }
}

extension UIView {
    /// 吐司效果
    func toast(_ message: String?, type: ToastType = .nore, seconds: TimeInterval = 2)  {
        guard let message = message else { return }
        
        if let lastView = subviews.last as? CCToastView { lastView.removeFromSuperview() }
        
        let toastView = CCToastView(message, type: type)
        addSubview(toastView)
        toastView.snp.remakeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.greaterThanOrEqualTo(110)
            make.width.lessThanOrEqualToSuperview().offset(-40)
            make.height.lessThanOrEqualToSuperview().offset(-200)
        }
        
        UIView.animate(withDuration: 0.2, delay: seconds, options: .curveEaseInOut) {
            toastView.alpha = 0
        } completion: {_ in
            toastView.removeFromSuperview()
        }
    }
}
