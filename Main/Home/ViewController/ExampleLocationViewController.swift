//
//  ExampleLocationViewController.swift
//  HelloSwift
//
//  Created by well on 2023/4/24.
//

import Foundation

class ExampleLocationViewController: BaseViewController, ExampleProtocol {
    lazy var locationManager: LocationManager = LocationManager()
    
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
                button.setTitle("开始地理定位", for: .normal)
            }
            if idx == 2 {
                button.setTitle("停止地理定位", for: .normal)
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
            locationManager.requestLocation { l in
                kPrint(l.coordinate.latitude)
                kPrint(l.coordinate.longitude)
            }
        case 102:
            locationManager.stop()
        default: break
        }
    }
}
