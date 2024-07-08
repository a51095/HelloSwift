enum ResponseType {
    case array
    case dictionary
}

/// - Parameters:
///   - url: 请求接口API(String类型)
///   - method: 请求方法(HTTPMethod)
///   - parameters: 请求参数(Dictionary<String, Any>类型)
///   - showErrorMsg: 响应错误信息(可自定义，默认值,String类型)
///   - encoding: 请求编码格式(URLEncoding)
///   - responseType: 响应报文类型(ResponseType))
///   - response: 响应报文(逃逸闭包)

/// method - get
// #mark - NetworkRequest
func NetworkRequest(url: String, method: HTTPMethod = .get, showErrorMsg: Bool = true, encoding: ParameterEncoding = URLEncoding.default, responseType: ResponseType = .array, response: @escaping ((Any?) -> Void)) {
    
    DispatchQueue.main.async { kAppDelegate.window!!.showLoading() }
    AF.request(url, method: method, parameters: nil, encoding: encoding).response { (res: AFDataResponse) in
        DispatchQueue.main.async { kAppDelegate.window!!.hideLoading() }
        
        switch res.result {
        case .success(let data):
            switch responseType {
            case .array:
                let object = try? JSONSerialization.jsonObject(with: data!, options: [])
                if let array = object as? [[String: Any]] {
                    response(array)
                } else {
                    if showErrorMsg { kAppDelegate.window!!.toast("出错啦", type: .failure); return }
                    response(nil)
                }
            case .dictionary:
                let object = try? JSONSerialization.jsonObject(with: data!, options: [])
                if let dictionary = object as? [String: Any] {
                    response(dictionary)
                } else {
                    if showErrorMsg { kAppDelegate.window!!.toast("出错啦", type: .failure); return }
                    response(nil)
                }
            }
        case .failure(let error):
            if showErrorMsg { kAppDelegate.window!!.toast(error.localizedDescription, type: .failure); return }
            response(nil)
        }
    }
}

/// method - post
// #mark - NetworkRequest
func NetworkRequest(url: String, method: HTTPMethod = .post, parameters: [String: Any] = [:], showErrorMsg: Bool = true, encoding: ParameterEncoding = URLEncoding.httpBody, responseType: ResponseType = .dictionary, response: @escaping ((Any?) -> Void)) {
    
    DispatchQueue.main.async { kAppDelegate.window!!.showLoading() }
    AF.request(url, method: method, parameters: parameters, encoding: encoding).response { (res: AFDataResponse) in
        DispatchQueue.main.async { kAppDelegate.window!!.hideLoading() }
        
        switch res.result {
        case .success(let data):
            switch responseType {
            case .array:
                let object = try? JSONSerialization.jsonObject(with: data!, options: [])
                if let array = object as? [[String: Any]] {
                    response(array)
                } else {
                    if showErrorMsg { kAppDelegate.window!!.toast("出错啦", type: .failure); return }
                    response(nil)
                }
            case .dictionary:
                let object = try? JSONSerialization.jsonObject(with: data!, options: [])
                if let dictionary = object as? [String: Any] {
                    response(dictionary)
                } else {
                    if showErrorMsg { kAppDelegate.window!!.toast("出错啦", type: .failure); return }
                    response(nil)
                }
            }
        case .failure(let error):
            if showErrorMsg { kAppDelegate.window!!.toast(error.localizedDescription, type: .failure); return }
            response(nil)
        }
    }
}
