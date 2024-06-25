extension UIView {
    /// 获取当前view所属vc
    func currentViewController() -> UIViewController? {
        var nextResponder: UIResponder? = self
    
        while let responder = nextResponder {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            nextResponder = responder.next
        }
    
        return nil
    }

    /// 将View转换为UIImage(屏幕截图)
    func toImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        self.layer.render(in: context!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}
