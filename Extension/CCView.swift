//
//  CCView.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/15.
//

extension UIView {
    /// 获取当前view所属vc
    func getCurrentViewController() -> UIViewController? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self) {
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
}
