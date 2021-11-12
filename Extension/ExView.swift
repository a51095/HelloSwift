//
//  ExView.swift
//  DevHelper
//
//  Created by a51095 on 2021/11/11.
//

public extension UIView {
    /// 获取当前view所属vc
    func currentViewController() -> UIViewController? {
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
