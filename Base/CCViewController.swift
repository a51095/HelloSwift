//
//  CCViewController.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/15.
//

import UIKit

class CCViewController: UIViewController, CCNetworkStatusProtocol {
    
    /// 自定义顶部视图(默认白色背景色)
    public lazy var barView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    /// 自定义返回按钮(默认黑色)
    public lazy var backButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.vc_back_black(), for: .normal)
        b.contentEdgeInsets = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
        b.addTarget(self, action: #selector(backButtonDidSeleted), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setBackgroundColor()
    }
    
    /// UI初始化(一个空的UI初始化方法,子类可继承重写)
    public func setUI() { }
    
    /// 设置视图控制器背景色(默认白色)
    public func setBackgroundColor() {
        view.backgroundColor = .white
    }
    
    /// 添加自定义顶部视图(默认白色背景色)
    public func addBarView() {
        let autoH = kSafeMarginTop(44)
        view.addSubview(barView)
        barView.snp.makeConstraints { make in
            make.height.equalTo(autoH)
            make.top.left.right.equalToSuperview()
        }
    }
    
    /// 添加自定义返回按钮(默认黑色)
    public func addBackButton() {
        if barView.superview != nil {
            barView.addSubview(backButton)
        }else {
            view.addSubview(backButton)
        }
        
        let autoY = kSafeMarginTop(44) / 2
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(autoY)
            make.left.equalToSuperview()
        }
    }
    
    /// 自定义返回按钮事件
    @objc func backButtonDidSeleted() {
        if self.navigationController?.visibleViewController != nil {
            self.navigationController?.popViewController(animated: true)
        }
        self.dismiss(animated: true)
    }
}
