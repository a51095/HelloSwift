//
//  Network.swift
//  HelloSwift
//
//  Created by well on 2021/9/10.
//

/// 自定义响应数据结构(目的在于封装的请求方法仅一个回调即可获取成功与失败两种状态)
struct ResponseData {
    let resCode: Int
    let data: [String: Any]?
    
    init(resCode: Int = -1, data: [String: Any]? = nil) {
        self.resCode = resCode
        self.data = data
    }
}

// MARK: - NetworkRequest
/// - url:                                 请求接口API(String类型)
/// - method:                        请求方法(默认post)
/// - parameters:      请求参数(Dictionary<String, Any>类型)
/// - showError:                    响应错误信息(可自定义，默认值,String类型)
/// - encoding:                     请求编码格式(URLEncoding默认类型)
/// - response:                     响应回调结果(逃逸闭包)

// MARK: 通用的网络请求方法
func NetworkRequest(url: String, method: HTTPMethod = .post, parameters: [String: Any] = [:], showErrorMsg: Bool = true, encoding: ParameterEncoding = URLEncoding.httpBody, response: @escaping ((ResponseData) -> Void)) {
    // 公共参数
    var commonParam = ["uid": AppKey.freeUid, "appkey": AppKey.freeAppKey] as [String: Any]
    // 合并请求参数
    if !parameters.isEmpty { commonParam.merge(dict: parameters) }
    
    kAppDelegate.window!!.showLoading()
    AF.request(url, method: method, parameters: commonParam, encoding: encoding).response { (res: AFDataResponse) in
        kAppDelegate.window!!.hideLoading()
        
        switch res.result {
        case .success(let data):
            let object = try? JSONSerialization.jsonObject(with: data!, options: .fragmentsAllowed)
            if let dic = object as? [String: Any] {
                if let code = dic["code"] as? String {
                    let data = ResponseData(resCode: code.i!, data: dic)
                    response(data)
                } else {
                    if showErrorMsg { kAppDelegate.window!!.toast("出错啦", type: .failure); return }
                    response(ResponseData());
                }
            } else {
                if showErrorMsg { kAppDelegate.window!!.toast("出错啦", type: .failure); return }
                response(ResponseData());
            }
        case .failure(let error):
            if showErrorMsg { kAppDelegate.window!!.toast(error.localizedDescription, type: .failure); return }
            response(ResponseData());
        }
    }
}

