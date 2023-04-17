//
//  ExampleLoadingViewController.swift
//  HelloSwift
//
//  Created by well on 2023/4/14.
//

import Foundation

class ExampleLoadingViewController: BaseViewController, ExampleProtocol {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSubview()
    }
    
    override func initSubview() {
        super.initSubview()
            
        let count = 2
        let limitH = 36
        
        var buttonArray = [UIButton]()
        for (idx) in 1...count {
            let button = UIButton()
            button.tag = idx + 100
            button.backgroundColor = .orange
            button.setTitle("样式 \(convertToNumber(String(idx)))", for: .normal)
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
            view.showLoading()
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 3) {
                self.view.hideLoading()
            }
        case 102:
            view.showLoading("带文字加载转圈")
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 3) {
                self.view.hideLoading()
            }
        default: break
        }
    }
}
