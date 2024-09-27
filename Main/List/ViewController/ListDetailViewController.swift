import UIKit
import Foundation

class ListDetailViewController: BaseViewController {
    private var newsId: String
    /// 新闻数据源
    private var dataSource = [DetailModel]()
    /// 懒加载,新闻详情控件
    private lazy var tableView: UITableView = {
        let v = UITableView()
        v.delegate = self
        v.dataSource = self
        v.separatorStyle = .none
        v.estimatedRowHeight = 100
        v.alwaysBounceVertical = false
        v.rowHeight = UITableView.automaticDimension
        v.register(DetailCell.self, forCellReuseIdentifier: DetailCell.classString)
        return v
    }()
    
    init(newsId: String) {
        self.newsId = newsId
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
    
    override func initData() {
        super.initData()
        fetchRollNewsDetail()
    }
    
    override func initSubview() {
        super.initSubview()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func reloadDataIfNeed() {
        guard !dataSource.isEmpty else { return }
        self.tableView.reloadData()
    }
    
    /// 获取新闻数据
    private func fetchRollNewsDetail() {
        let url = AppURL.rollDetailUrl + "newsId=\(newsId)" + "&" + "app_id=\(AppKey.rollAppKey)" + "&" + "app_secret=\(AppKey.rollSecretKey)"
        NetworkRequest(url: url, method: .get, responseType: .dictionary) { res in
            
            // 容错处理
            guard res != nil else { return }
            
            if let dictionary = res as? [String: Any] {
                
                guard let code = dictionary["code"] as? Int, code == 1 else {
                    return kTopViewController.view.toast("暂无数据~", type: .failure)
                }
                
                if let data = dictionary["data"] as? [String: Any] {
                    if let array = data["items"] as? [[String: Any]] {
                        array.forEach { dict in
                            guard let model = DetailModel.deserialize(from: dict) else { return }
                            self.dataSource.append(model)
                        }
                    }
                }
                
                self.reloadDataIfNeed()
            }
        }
    }
}

extension ListDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: DetailCell.self, for: indexPath)
        let item = dataSource[indexPath.row]
        cell.reloadCell(item: item)
        return cell
    }
}
