//
//  TextView.swift
//  HelloSwift
//
//  Created by well on 2024/9/29.
//

import UIKit

// view.addSubview(textView)
// textView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
// textView.center = view.center
// textView.placeholder = "请输入内容..."
// textView.placeholderColor = .orange
// textView.backgroundColor = .lightGray
// textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

class TextView: UITextView {
    
    // 占位符
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
            updatePlaceholderVisibility()
        }
    }
    
    // 占位字体
    var placeholderFont: UIFont? {
        didSet {
            placeholderLabel.font = placeholderFont
            layoutPlaceholderLabel()
        }
    }
    
    // 占位颜色
    var placeholderColor: UIColor? {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    // 占位UILabel
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = placeholder
        label.textColor = textColor
        label.font = .systemFont(ofSize: 17.0)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override var textContainerInset: UIEdgeInsets {
        didSet {
            layoutPlaceholderLabel()
        }
    }
    
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
        textContainerInset = .zero
        font = .systemFont(ofSize: 17.0)
        textContainer.lineFragmentPadding = 0
    }
    
    private func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        placeholderLabel.isHidden = true
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        updatePlaceholderVisibility()
    }
    
    private func addObserverForTextChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
    }
    
    private func removeObserverForTextChange() {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: self)
    }
    
    @objc private func textDidChange(notification: Notification) {
        updatePlaceholderVisibility()
    }
    
    override var text: String! {
        didSet {
            updatePlaceholderVisibility()
        }
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

