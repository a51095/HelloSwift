enum ResponseType {
    case array
    case dictionary
}

/// 默认 get 请求、响应报文为 array
/// - Parameters:
///   - url: 请求URL
///   - method: 请求方法
///   - parameters: 请求参数
///   - showErrorMsg: 是否toast提示
///   - encoding: 编码类型
///   - responseType: 响应类型
///   - response: 响应报文
func NetworkRequest(url: String, method: HTTPMethod = .get, showErrorMsg: Bool = true, encoding: ParameterEncoding = URLEncoding.default, responseType: ResponseType = .array, response: @escaping ((Any?) -> Void)) {
    
    DispatchQueue.main.async { kAppDelegate.window!!.showLoading() }
    AF.request(url, method: method, parameters: nil, encoding: encoding).response { (res: AFDataResponse) in
        DispatchQueue.main.async { kAppDelegate.window!!.hideLoading() }
        switch res.result {
            case .success(let data):
                switch responseType {
                    case .array:
                        let object = try? JSONSerialization.jsonObject(with: data!)
                        if let array = object as? [[String: Any]] {
                            response(array)
                        } else {
                            if showErrorMsg {
                                DispatchQueue.main.async { kAppDelegate.window!!.toast("出错啦", type: .failure) }
                                return
                            }
                            response(nil)
                        }
                    case .dictionary:
                        let object = try? JSONSerialization.jsonObject(with: data!)
                        if let dictionary = object as? [String: Any] {
                            response(dictionary)
                        } else {
                            if showErrorMsg {
                                DispatchQueue.main.async { kAppDelegate.window!!.toast("出错啦", type: .failure) }
                                return
                            }
                            response(nil)
                        }
                }
            case .failure(let error):
                if showErrorMsg {
                    DispatchQueue.main.async { kAppDelegate.window!!.toast(error.localizedDescription, type: .failure) }
                    return
                }
                response(nil)
        }
    }
}

/// 默认 post 请求、响应报文为 dictionary
/// - Parameters:
///   - url: 请求URL
///   - method: 请求方法
///   - headers: 请求头
///   - parameters: 请求参数
///   - showErrorMsg: 是否toast提示
///   - encoding: 编码类型
///   - responseType: 响应类型
///   - response: 响应报文
func NetworkRequest(url: String, method: HTTPMethod = .post, headers: HTTPHeaders? = nil, parameters: [String: Any] = [:], showErrorMsg: Bool = true, encoding: ParameterEncoding = URLEncoding.httpBody, responseType: ResponseType = .dictionary, response: @escaping ((Any?) -> Void)) {
    
    DispatchQueue.main.async { kAppDelegate.window!!.showLoading() }
    AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).response { (res: AFDataResponse) in
        DispatchQueue.main.async { kAppDelegate.window!!.hideLoading() }
        
        switch res.result {
            case .success(let data):
                switch responseType {
                    case .array:
                        let object = try? JSONSerialization.jsonObject(with: data!, options: [])
                        if let array = object as? [[String: Any]] {
                            response(array)
                        } else {
                            if showErrorMsg {
                                DispatchQueue.main.async { kAppDelegate.window!!.toast("出错啦", type: .failure) }
                                return
                            }
                            response(nil)
                        }
                    case .dictionary:
                        let object = try? JSONSerialization.jsonObject(with: data!, options: [])
                        if let dictionary = object as? [String: Any] {
                            response(dictionary)
                        } else {
                            if showErrorMsg {
                                DispatchQueue.main.async { kAppDelegate.window!!.toast("出错啦", type: .failure) }
                                return
                            }
                            response(nil)
                        }
                }
            case .failure(let error):
                kPrint(String(format: error.localizedDescription))
                if showErrorMsg {
                    DispatchQueue.main.async { kAppDelegate.window!!.toast(error.localizedDescription, type: .failure) }
                    return
                }
                response(nil)
        }
    }
}
