//
//  ExamplePropertyViewController.swift
//  HelloSwift
//
//  Created by well on 2024/2/22.
//

import Foundation

class ExamplePropertyViewController: BaseViewController, ExampleProtocol {

	@StringPreference(key: "exampleName")
	var exampleName: String

	override func viewDidLoad() {
		super.viewDidLoad()
		self.initSubview()
	}

	override func initSubview() {
		super.initSubview()

		let count = 3
		let limitH = 50

		let buttonTitleArray = ["重置默认值", "设置新值", "查看当前值"]

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
				exampleName = "默认值"
			case 102:
				exampleName = "新值"
			case 103:
				print("exampleName ==>> ", exampleName)
			default: break
		}
	}
}
