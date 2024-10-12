//
//  TextField.swift
//  HelloSwift
//
//  Created by well on 2024/9/30.
//

import UIKit

// lazy var textField = TextField()
// view.addSubview(textField)
// textField.frame = CGRect(x: 0, y: 0, width: 400, height: 60)
// textField.center = view.center
// textField.placeholder = "请输入内容..."
// textField.placeholderFont = .systemFont(ofSize: 20)
// textField.placeholderColor = .red
// textField.isEnableDecimalLimit = true
// textField.offset = CGPoint(x: 10, y: 10)
// textField.font = .systemFont(ofSize: 30)
// textField.backgroundColor = .lightGray
// textField.keyboardType = .decimalPad

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
    var isEnableDecimalLimit: Bool = false {
        willSet {
            if newValue && delegate == nil {
                delegate = self
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}

extension TextField {
    private func rect(forBounds bounds: CGRect) -> CGRect {
        let leftViewWidth = leftView?.bounds.width ?? 0.0
        let xAdjustment = leftViewWidth + offset.x
        let width = bounds.width - leftViewWidth - abs(offset.x)
        return CGRect(x: bounds.origin.x + xAdjustment,
                      y: bounds.origin.y + offset.y,
                      width: width,
                      height: bounds.height)
    }
    /// 占位符偏移量
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return rect(forBounds: bounds)
    }
    
    /// 文本最终显示偏移量
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return rect(forBounds: bounds)
    }
    
    /// 文本编辑时偏移量
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return rect(forBounds: bounds)
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
        if ((expression?.firstMatch(in: currentText, options: [], range: NSRange(location: 0, length: currentText.utf16.count))) != nil) {
            return true
        }
        
        // 若不符合正则表达式，则不允许更改
        return false
    }
}
