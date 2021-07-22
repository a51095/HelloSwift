//
//  CCViewController.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/15.
//

import UIKit

class CCViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setBackgroundColor()
    }
    
    /// UI初始化(一个空的UI初始化方法,子类可继承重写)
    func setUI() { }
    
    /// 设置视图控制器背景色(默认白色)
    func setBackgroundColor() {
        view.backgroundColor = .white
    }
}
