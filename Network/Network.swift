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
    
    init(resCode: Int = -1, data: [String : Any]? = nil) {
        self.resCode = resCode
        self.data = data
    }
}

// MARK: - NetworkRequest
/// - url:                                 请求接口API(String类型)
/// - method:                        请求方法(默认post)
/// - parameters:      请求参数(Dictionary<String, Any>类型)
/// - showError:                    响应错误信息(可自定义默认值,String类型)
/// - encoding:                     请求编码格式(URLEncoding默认类型)
/// - response:                     响应回调结果(逃逸闭包)

// MARK: 通用的网络请求方法
func NetworkRequest(url: String, method: HTTPMethod = .post, parameters: [String: Any] = [:], showErrorMsg: Bool = true, encoding: URLEncoding = .default, response: @escaping ((ResponseData) -> Void)) {
    // 公共参数
    var commonParam = ["uid": AppKey.freeUid, "appkey": AppKey.freeAppKey] as [String: Any]
    // 合并请求参数
    if !parameters.isEmpty { commonParam.merge(dict: parameters) }
    
    kAppDelegate().window!!.showLoading()
    AF.request(url, method: method, parameters: commonParam, encoding: encoding).responseJSON { res in
        kAppDelegate().window!!.hideLoading()
        // 容错处理,若请求报错error,则直接返回默认数据
        guard res.error == nil else {
            if showErrorMsg {
                kAppDelegate().window!!.toast("出错啦", type: .failure)
            }
            response(ResponseData());
            return
        }
        
        // 容错处理,若请求res.value空值,则直接返回默认数据
        guard let dic = res.value as? [String: Any] else {
            if showErrorMsg {
                kAppDelegate().window!!.toast("出错啦", type: .failure)
            }
            response(ResponseData());
            return
        }
        
        // 容错处理,若请求code空值,则直接返回默认数据
        guard let code = dic["code"] as? String else {
            if showErrorMsg {
                kAppDelegate().window!!.toast("出错啦", type: .failure)
            }
            response(ResponseData());
            return
        }
        
        let data = ResponseData(resCode: code.i!, data: dic)
        response(data)
    }
}

