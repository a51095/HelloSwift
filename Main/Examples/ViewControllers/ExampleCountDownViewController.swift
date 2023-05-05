//
//  ExampleCountDownViewController.swift
//  HelloSwift
//
//  Created by well on 2023/4/24.
//

import Foundation

class ExampleCountDownViewController: BaseViewController, ExampleProtocol {
    lazy var countDownView: CountDownView = {
        let c = CountDownView()
        c.layer.cornerRadius = 6
        c.backgroundColor = .main
        c.layer.masksToBounds = true
        return c
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSubview()
    }
    
    override func initSubview() {
        super.initSubview()
        
        view.addSubview(countDownView)
        countDownView.snp.makeConstraints { (make) in
            make.height.equalTo(60)
            make.width.equalTo(280)
            make.center.equalToSuperview()
        }
    }
}
