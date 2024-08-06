import UIKit
import WebKit
import SwiftyJSON
import Foundation

class ListDetailViewController: BaseViewController {
    /// 新闻ID
    private var uniquekey: String
    /// 新闻数据源
    var detailModel: DetailModel?

    private var webView = WKWebView()
    
    init(uniquekey: String) {
        self.uniquekey = uniquekey
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSubview()
        self.initData()
    }
    
    override func initData() { fetchNewsData() }
    
    override func initSubview() {
        // 网络校验,有网则执行后续操作,网络不可用,则直接返回
        guard isReachable else { return }
        super.initSubview()
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }

    private func reloadDataIfNeed() {
        guard let content = detailModel?.content else { return }
        webView.loadHTMLString(content, baseURL: nil)
    }
    
    /// 获取新闻数据
    func fetchNewsData() {
        let parameters: [String: Any] = ["uniquekey": uniquekey, "key": AppKey.newsKey]
        NetworkRequest(url: AppURL.toutiaoContentUrl, parameters: parameters) { res in
            // 容错处理
            guard res != nil else { return }
            
            if let dictionary = res as? [String: Any] {
                let errorCode = dictionary["error_code"] as! Int
                guard errorCode == 0 else { self.webView.toast("暂无数据", type: .failure); return }
                let json = JSON(dictionary)
                self.detailModel = DetailModel(jsonData: json)
                self.reloadDataIfNeed()
            }
        }
    }
}
