/// 通用的网络请求方法
/// - Parameters:
///   - url: 请求接口API(String类型)
///   - method: 请求方法(默认post)
///   - parameters: 请求参数(Dictionary<String, Any>类型)
///   - showErrorMsg: 响应错误信息(可自定义，默认值,String类型)
///   - encoding: 请求编码格式(URLEncoding默认类型)
///   - response: 响应报文(逃逸闭包)
func NetworkRequest(url: String, method: HTTPMethod = .post, parameters: [String: Any] = [:], showErrorMsg: Bool = true, encoding: ParameterEncoding = URLEncoding.httpBody, response: @escaping (([String: Any]?) -> Void)) {
    
    DispatchQueue.main.async { kAppDelegate.window!!.showLoading() }
    AF.request(url, method: method, parameters: parameters, encoding: encoding).response { (res: AFDataResponse) in
        DispatchQueue.main.async { kAppDelegate.window!!.hideLoading() }
        
        switch res.result {
        case .success(let data):
            let object = try? JSONSerialization.jsonObject(with: data!, options: .fragmentsAllowed)
            if let dic = object as? [String: Any] {
                response(dic)
            } else {
                if showErrorMsg { kAppDelegate.window!!.toast("出错啦", type: .failure); return }
                response(nil)
            }
        case .failure(let error):
            if showErrorMsg { kAppDelegate.window!!.toast(error.localizedDescription, type: .failure); return }
            response(nil)
        }
    }
}

