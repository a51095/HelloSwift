//
//  TextField.swift
//  HelloSwift
//
//  Created by well on 2024/9/30.
//

import UIKit

//lazy var textField = TextField()
//view.addSubview(textField)
//textField.frame = CGRect(x: 0, y: 0, width: 400, height: 60)
//textField.center = view.center
//textField.placeholder = "请输入内容..."
//textField.placeholderFont = .systemFont(ofSize: 17)
//textField.placeholderColor = .red
//textField.isEnableDecimalLimit = true
//textField.offset = CGPoint(x: 10, y: 10)
//textField.font = .systemFont(ofSize: 17)
//textField.backgroundColor = .lightGray
//textField.keyboardType = .decimalPad

class TextField: UITextField {
    /// 占位字体
    var placeholderFont: UIFont? {
        willSet {
            if let label = value(forKey: "placeholderLabel") as? UILabel {
                label.font = newValue
            }
        }
    }
    
    /// 占位颜色
    var placeholderColor: UIColor? {
        willSet {
            if let label = value(forKey: "placeholderLabel") as? UILabel {
                label.textColor = newValue
            }
        }
    }
    
    /// 内边距偏移量
    var offset: CGPoint = .zero
    
    /// 是否启用小数点后仅允许两位的输入限制
    var isEnableDecimalLimit: Bool = false
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
    }
}

extension TextField {
    /// 占位符偏移量
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        if let leftView {
            return CGRectOffset(CGRect(origin: bounds.origin, size: CGSize(width: bounds.width - leftView.bounds.width - offset.x, height: bounds.height)), leftView.bounds.width + offset.x, offset.y)
        }
        return CGRectOffset(CGRect(origin: bounds.origin, size: CGSize(width: bounds.width - offset.x, height: bounds.height)), offset.x, offset.y)
    }
    
    /// 文本最终显示偏移量
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        if let leftView {
            return CGRectOffset(CGRect(origin: bounds.origin, size: CGSize(width: bounds.width - leftView.bounds.width - offset.x, height: bounds.height)), leftView.bounds.width + offset.x, offset.y)
        }
        return CGRectOffset(CGRect(origin: bounds.origin, size: CGSize(width: bounds.width - offset.x, height: bounds.height)), offset.x, offset.y)
    }
    
    /// 文本编辑时偏移量
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        if let leftView {
            return CGRectOffset(CGRect(origin: bounds.origin, size: CGSize(width: bounds.width - leftView.bounds.width - offset.x, height: bounds.height)), leftView.bounds.width + offset.x, offset.y)
        }
        return CGRectOffset(CGRect(origin: bounds.origin, size: CGSize(width: bounds.width - offset.x, height: bounds.height)), offset.x, offset.y)
    }
}

extension TextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard isEnableDecimalLimit else { return true }
        
        // 获取当前文本
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
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
