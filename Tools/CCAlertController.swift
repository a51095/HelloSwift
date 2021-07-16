//
//  CCAlertController.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/15.
//

import UIKit
import SnapKit

struct CCAlertAction {
    var title: String
    var titleColor: UIColor
    var handler: os_block_t?
    
    init(title: String, titleColor: UIColor = .black, handler: os_block_t? = nil ) {
        self.title = title
        self.titleColor = titleColor
        self.handler = handler
    }
}

class CCAlertController: UIViewController {

    let limitSpace = 20 // title与message与stackView间距
    
    var alertTitle: String?
    var alertMessage: String?
    var alertAction: [CCAlertAction]
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 反初始化器
    deinit {
        print("CCAlertController deinit~")
    }
    
    // MARK: - 自定义初始化方法
    init(_ title: String?, _ message: String?, _ actions: [CCAlertAction])  {
        
        self.alertTitle = title
        self.alertMessage = message
        self.alertAction = actions
        
        super.init(nibName: nil, bundle: nil)
        
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    
    // MARK: - UI初始化
    func setUI() {
        
        view.backgroundColor = .hexColor("#000000", 0.2)
        
        let backgroundView = UIView()
        backgroundView.layer.cornerRadius = 6
        backgroundView.backgroundColor = .white
        self.view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.left.equalTo(36)
            make.right.equalTo(-36)
            make.centerY.equalToSuperview()
            make.height.greaterThanOrEqualTo(50)
        }
                
        var buttonArray = [UIButton]()
        for (idx,item) in alertAction.enumerated() {
            let button = UIButton()
            button.tag = idx + 100
            button.setTitle(item.title, for: .normal)
            button.setTitleColor(item.titleColor, for: .normal)
            button.addTarget(self, action: #selector(alertActionDidSeleted(button:)), for: .touchUpInside)
            buttonArray.append(button)
        }
        
        let stackView = UIStackView(arrangedSubviews: buttonArray)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        backgroundView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.left.right.bottom.equalToSuperview()
        }
        
        // 水平分割线
        let horizontalLineView = UIView()
        horizontalLineView.backgroundColor = .hexColor("#E3E3E3")
        
        stackView.addSubview(horizontalLineView)
        horizontalLineView.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.top.left.right.equalToSuperview()
        }
        
        if alertAction.count == 2 {
            // 垂直分割线
            let verticalLineView = UIView()
            verticalLineView.backgroundColor = .hexColor("#E3E3E3")
            stackView.addSubview(verticalLineView)
            verticalLineView.snp.makeConstraints { (make) in
                make.width.equalTo(0.5)
                make.height.equalToSuperview()
                make.centerX.equalToSuperview()
            }
        }
        
        // 样式1,有标题,有描述
        if (alertTitle != nil && alertTitle?.count != 0) && (alertMessage != nil && alertMessage?.count != 0 ){
            let titleLabel = UILabel()
            titleLabel.textColor = .black
            titleLabel.text = self.alertTitle
            titleLabel.textAlignment = .center
            titleLabel.font = SemiblodFont(18)
            backgroundView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(10)
                make.right.equalTo(-10)
                make.top.equalTo(limitSpace)
            }

            let messageLabel = UILabel()
            messageLabel.numberOfLines = 10
            messageLabel.font = RegularFont(16)
            messageLabel.textAlignment = .center
            messageLabel.text = self.alertMessage
            messageLabel.textColor = .hexColor("#999999")
            backgroundView.addSubview(messageLabel)
            messageLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(-(50 + limitSpace))
                make.width.lessThanOrEqualToSuperview().offset(-50)
                make.top.equalTo(titleLabel.snp.bottom).offset(limitSpace)
            }
            return
        }
        
        // 样式2,有标题,无描述
        if (alertTitle != nil && alertTitle?.count != 0 ) && (alertMessage == nil || alertMessage?.count == 0) {
            let titleLabel = UILabel()
            titleLabel.textColor = .black
            titleLabel.text = self.alertTitle
            titleLabel.textAlignment = .center
            titleLabel.font = SemiblodFont(18)
            backgroundView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(10)
                make.left.equalTo(10)
                make.right.equalTo(-10)
                make.bottom.equalTo((-(50 + limitSpace)))
            }
            return
        }
        
        // 样式3,无标题,有描述
        if (alertTitle == nil || alertTitle?.count == 0 ) && (alertMessage != nil && alertMessage?.count != 0) {
            let messageLabel = UILabel()
            messageLabel.numberOfLines = 10
            messageLabel.font = RegularFont(16)
            messageLabel.textAlignment = .center
            messageLabel.text = self.alertMessage
            messageLabel.textColor = .hexColor("#999999")
            backgroundView.addSubview(messageLabel)
            messageLabel.snp.makeConstraints { (make) in
                make.top.equalTo(10)
                make.centerX.equalToSuperview()
                make.width.lessThanOrEqualToSuperview().offset(-50)
                make.bottom.equalTo((-(50 + limitSpace)))
            }
            return
        }
    }
    
    // MARK: - action点击事件
    @objc func alertActionDidSeleted(button: UIButton) {
        self.dismiss(animated: true) {
            let action = self.alertAction[button.tag - 100]
            action.handler?()
        }
    }
}

extension UIViewController {
    func alert(_ title: String?, _ message: String?, _ actions: [CCAlertAction] )  {
        let vc = CCAlertController(title, message, actions)
        present(vc, animated: true, completion: nil)
    }
}

extension UIView {
    func alert(_ title: String?, _ message: String?, _ actions: [CCAlertAction] )  {
        self.getCurrentViewController()?.alert(title, message, actions)
    }
}
