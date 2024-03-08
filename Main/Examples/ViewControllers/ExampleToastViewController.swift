//
//  ExampleToastViewController.swift
//  HelloSwift
//
//  Created by well on 2023/4/14.
//

import Foundation

class ExampleToastViewController: BaseViewController, ExampleProtocol {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSubview()
    }
    
    override func initSubview() {
        super.initSubview()
            
        let count = 3
        let limitH = 50
		let buttonTitleArray = ["样式 一", "样式 二", "样式 三"]
		
        var buttonArray = [UIButton]()
        for (idx) in 1...count {
            let button = UIButton()
            button.tag = idx + 100
            button.backgroundColor = .orange
			button.setTitle(buttonTitleArray[idx - 1], for: .normal)
            button.layer.cornerRadius = 8
            button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(didSeleted(button:)), for: .touchUpInside)
            button.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize(width: 200, height: limitH))
            }
            buttonArray.append(button)
        }
        
        let stackView = UIStackView(arrangedSubviews: buttonArray)
        stackView.axis = .vertical
        stackView.spacing = CGFloat(limitH)
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(view.snp_leftMargin).offset(20)
            make.right.equalTo(view.snp_rightMargin).offset(-20)
            make.height.equalTo(2 * count * limitH)
        }
    }
    
    @objc func didSeleted(button: UIButton) {
        switch button.tag {
        case 101:
            view.toast("仅文字，无图标")
        case 102:
            view.toast("成功提示", type: .success)
        case 103:
            view.toast("失败提示", type: .failure)
        default: break
        }
    }
}
