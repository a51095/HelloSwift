//
//  CCNavigationController.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/15.
//

import UIKit

class CCNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    
    // MARK: - UI初始化
    func setUI() {
        navigationBar.isHidden = true
    }
}
