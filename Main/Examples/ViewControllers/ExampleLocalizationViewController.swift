//
//  ExampleLocalizationViewController.swift
//  HelloSwift
//
//  Created by neusoft on 2024/3/25.
//

import Foundation

class ExampleLocalizationViewController: BaseViewController, ExampleProtocol {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSubview()
    }

    override func initSubview() {
        super.initSubview()

        let count = 3
        let limitH = 50
        let buttonTitleArray = ["English", "简体中文", "繁體中文"]

        var buttonArray = [UIButton]()
        for (idx) in 1...count {
            let button = UIButton()
            button.tag = idx + 100
            button.backgroundColor = .orange
            button.setTitle(buttonTitleArray[idx - 1], for: .normal)
            button.layer.cornerRadius = 8
            button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(didSelect(button:)), for: .touchUpInside)
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

    @objc func didSelect(button: UIButton) {
        switch button.tag {
            case 101:
                alert(message: kLocalization.localizationMessage, buttonText: kLocalization.commonYES) {
                    Cache.setString(LanguageCode.en.rawValue, forKey: AppKey.localizationKey)
                    exit(0)
                }
            case 102:
                alert(message: kLocalization.localizationMessage, buttonText: kLocalization.commonYES) {
                    Cache.setString(LanguageCode.zh.rawValue, forKey: AppKey.localizationKey)
                    exit(0)
                }
            case 103:
                alert(message: kLocalization.localizationMessage, buttonText: kLocalization.commonYES) {
                    Cache.setString(LanguageCode.tw.rawValue, forKey: AppKey.localizationKey)
                    exit(0)
                }
            default: break
        }
    }
}
