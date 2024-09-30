//
//  TextView.swift
//  HelloSwift
//
//  Created by well on 2024/9/29.
//

import UIKit

//view.addSubview(textView)
//textView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
//textView.center = view.center
//textView.placeholder = "请输入内容..."
//textView.placeholderColor = .orange
//textView.backgroundColor = .lightGray
//textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

class TextView: UITextView {
    
    /// 占位符
    var placeholder: String? {
        willSet {
            placeholderLabel.text = newValue
            updatePlaceholderVisibility()
        }
    }
    
    /// 占位字体
    var placeholderFont: UIFont? {
        willSet {
            placeholderLabel.font = newValue
            layoutPlaceholderLabel()
        }
    }
    
    /// 占位颜色
    var placeholderColor: UIColor? {
        willSet {
            placeholderLabel.textColor = newValue
        }
    }
    
    /// 是否启用小数点后仅允许两位的输入限制
    var isEnableDecimalLimit: Bool = false
    
    /// override text
    override var text: String! {
        didSet {
            updatePlaceholderVisibility()
        }
    }
    
    /// override textContainerInset
    override var textContainerInset: UIEdgeInsets {
        didSet {
            layoutPlaceholderLabel()
        }
    }
    
    /// 占位UILabel
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = placeholder
        label.textColor = textColor
        label.font = .systemFont(ofSize: 17.0)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        defaultConfig()
        setupPlaceholderLabel()
        addKeyboardNotifications()
        addObserverForTextChange()
        updatePlaceholderVisibility()
    }
    
    deinit {
        removeKeyboardNotifications()
        removeObserverForTextChange()
    }
    
    private func defaultConfig() {
        delegate = self
        textContainerInset = .zero
        font = .systemFont(ofSize: 17.0)
        textContainer.lineFragmentPadding = 0
    }
            
    private func setupPlaceholderLabel() {
        if placeholderLabel.superview == nil {
            addSubview(placeholderLabel)
            layoutPlaceholderLabel()
        }
    }
    
    private func updatePlaceholderVisibility() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    private func layoutPlaceholderLabel() {
        if textContainerInset == UIEdgeInsets.zero {
            if let containerView = value(forKey: "containerView") as? UIView {
                placeholderLabel.frame = containerView.frame
            }
        } else {
            let insets = textContainerInset
            let size = placeholderLabel.sizeThatFits(bounds.inset(by: insets).size)
            let origin = CGPoint(x: insets.left, y: insets.top)
            placeholderLabel.frame = CGRect(origin: origin, size: size)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        layoutPlaceholderLabel()
    }
}

extension TextView {
    private func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// 监听键盘弹起
    @objc private func keyboardWillShow(notification: Notification) {
        placeholderLabel.isHidden = true
    }
    
    /// 监听键盘隐藏
    @objc private func keyboardWillHide(notification: Notification) {
        updatePlaceholderVisibility()
    }
}

extension TextView {
    private func addObserverForTextChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
    }
    
    private func removeObserverForTextChange() {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: self)
    }
    
    /// 监听文本内容更改
    @objc private func textDidChange(notification: Notification) {
        updatePlaceholderVisibility()
    }
}

extension TextView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard isEnableDecimalLimit else { return true }
        
        // 获取当前文本
        let currentText = (textView.text as NSString?)?.replacingCharacters(in: range, with: text) ?? ""
        
        // 正则表达式
        let regex = "^$|^0$|^0\\.[0-9]{0,2}$|^[1-9][0-9]*\\.?[0-9]{0,2}$"
        
        // 创建正则表达式对象
        let expression = try? NSRegularExpression(pattern: regex, options: [])
        
        // 校验当前文本是否符合正则表达式
        if let _ = expression?.firstMatch(in: currentText, options: [], range: NSRange(location: 0, length: currentText.utf16.count)) {
            return true
        }
        
        // 若不符合正则表达式，则不允许更改
        return false
    }
}
