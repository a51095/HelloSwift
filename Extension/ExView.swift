extension UIView {
    /// 获取当前view所属vc
    var currentViewController: UIViewController? {
        nextResponder(ofType: UIViewController.self)
    }
    
    /// 将View转换为UIImage(屏幕截图)
    func toImage() -> UIImage? {
        // 检查视图大小是否有效
        guard self.frame.size.width > 0 && self.frame.size.height > 0 else { return nil }
    
        // 创建图像上下文
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
    
        // 获取当前上下文
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
    
        // 渲染图层到上下文
        self.layer.render(in: context)
    
        // 获取当前图像    
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
