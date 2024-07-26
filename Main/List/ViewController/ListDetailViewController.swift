import UIKit
import SwiftyJSON
import Foundation

class ListDetailViewController: BaseViewController {
    /// 新闻ID
    private var uniquekey: String
    /// 新闻数据源
    private var dataSource = [DetailModel]()
    /// 懒加载,新闻详情控件
    private lazy var detailTableView: UITableView = {
        let v = UITableView()
        v.delegate = self
        v.dataSource = self
        v.separatorStyle = .none
        v.estimatedRowHeight = 100
        v.alwaysBounceVertical = false
        v.register(DetailCell.self, forCellReuseIdentifier: DetailCell.classString)
        return v
    }()
    
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
        view.addSubview(detailTableView)
        detailTableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }

    private func reloadDataIfNeed() {
        guard !dataSource.isEmpty else { return }
        self.detailTableView.reloadData()
    }
    
    /// 获取新闻数据
    func fetchNewsData() {
        let parameters: [String: Any] = ["uniquekey": uniquekey, "key": AppKey.newsKey]
        NetworkRequest(url: AppURL.toutiaoContentUrl, parameters: parameters) { res in
            // 容错处理
            guard res != nil else { return }
            
            if let dictionary = res as? [String: Any] {
                let errorCode = dictionary["error_code"] as! Int
                guard errorCode == 0 else { self.detailTableView.toast("暂无数据", type: .failure); return }
                let json = JSON(dictionary)
                let model = DetailModel(jsonData: json)
                self.dataSource.append(model)
                self.reloadDataIfNeed()
            }
        }
    }
}

extension ListDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var resources = [String]()
        
        if let thumbnail_pic_s = dataSource.first?.thumbnail_pic_s {
            resources.append(thumbnail_pic_s)
        }
        
        if let thumbnail_pic_s02 = dataSource.first?.thumbnail_pic_s02 {
            resources.append(thumbnail_pic_s02)
        }
        
        if let thumbnail_pic_s03 = dataSource.first?.thumbnail_pic_s03 {
            resources.append(thumbnail_pic_s03)
        }
        
        let headView = DetailHeadView(resources: resources)
        headView.backgroundColor = .clear
        headView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 260)
        return headView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: DetailCell.self, for: indexPath)
        let item = dataSource[indexPath.row]
        cell.reloadCell(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        260
    }
}
