extension UIResponder {
    func nextResponder<T: UIResponder>(ofType type: T.Type) -> T? {
        return next as? T ?? next?.nextResponder(ofType: type)
    }
}
