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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stop()
    }

    override func initSubview() {
        super.initSubview()

        let count = 2
        let limitH = 50
		let buttonTitleArray = ["开始地理定位", "停止地理定位"]

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
                switch locationManager.authStatus {
                    case .denied, .restricted:
                        if let url = URL(string:UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    case .notDetermined:
                        locationManager.requestAuthorization { status in
                            if status == .authorizedAlways || status == .authorizedWhenInUse {
                                self.locationManager.start { l in
                                    kPrint(l.coordinate.latitude)
                                    kPrint(l.coordinate.longitude)
                                }
                            }
                        }
                    case .authorized, .authorizedWhenInUse, .authorizedAlways:
                        locationManager.start { l in
                            kPrint(l.coordinate.latitude)
                            kPrint(l.coordinate.longitude)
                        }
                    default: break
                }
        case 102:
            locationManager.stop()
            kPrint("已停止地理定位")
        default: break
        }
    }
}
