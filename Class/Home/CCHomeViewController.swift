//
//  CCHomeViewController.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/14.
//

import UIKit

class CCHomeViewController: CCViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUI() {
        view.backgroundColor = .yellow
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.toast("哈哈")
    }
}
