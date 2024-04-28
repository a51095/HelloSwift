//
//  ExampleBluetoothViewController.swift
//  HelloSwift
//
//  Created by well on 2023/10/23.
//

import Foundation

class ExampleBluetoothViewController: BaseViewController, ExampleProtocol {
    lazy var bluetoothManager: BluetoothManager = BluetoothManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSubview()
        bluetoothManager.delegate = self
    }

    override func initSubview() {
        super.initSubview()

        let count = 2
        let limitH = 50
		let buttonTitleArray = ["开始蓝牙扫描", "停止蓝牙扫描"]

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
                make.size.equalTo(CGSize(width: 280, height: limitH))
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
            bluetoothManager.requestAuthorization { status in
                if status == .poweredOn {
                    self.bluetoothManager.startScanning()
                } else {
                    kPrint("请授权打开蓝牙开关")
                }
            }
        case 102:
            bluetoothManager.stopScan()
        default: break
        }
    }
}

extension ExampleBluetoothViewController: BleManagerDelegate {
    func bleManagerDidDiscoverPeripheral(result: DiscoverPeripheralResult) {
		print("result == \(String(describing: result.peripheral.name))")
    }
}
