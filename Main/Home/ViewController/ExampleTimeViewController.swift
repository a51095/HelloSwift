//
//  ExampleTimeViewController.swift
//  HelloSwift
//
//  Created by well on 2023/4/17.
//

import Foundation

class ExampleTimeViewController: BaseViewController, ExampleProtocol {
    lazy var timer: Timer = Timer()
    
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
            if idx == 1 {
                button.setTitle("开始定时器任务", for: .normal)
            }
            if idx == 2 {
                button.setTitle("停止定时器任务", for: .normal)
            }
            button.layer.cornerRadius = 8
            button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(didSeleted(button:)), for: .touchUpInside)
            button.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize(width:  280, height: limitH))
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
            make.height.equalTo(2 * count * limitH)
            make.left.right.centerY.equalToSuperview()
        }
    }
    
    @objc func didSeleted(button: UIButton) {
        switch button.tag {
        case 101:
            timer.start { kPrint("开始循环定时器任务") }
        case 102:
            timer.stop(); kPrint("停止循环定时器任务")
        default: break
        }
    }
}
