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
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hiddenPhoto))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
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
        
        view.addSubview(scrollView)
        scrollView.isHidden = true
        scrollView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
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
    
    func showPhoto(imageUrl: String) {
        hideTopViewAnimation()
        UIView.animate(withDuration: 0.25) {
            self.tableView.isHidden = true
            self.scrollView.isHidden = false
            self.scrollView.transform = CGAffineTransform(scaleX: 0, y: 0)
        } completion: { _ in
            self.scrollView.transform = .identity
            self.imageView.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named: "placeholder"))
            
            if let imageSize = self.imageView.image?.size {
                self.scrollView.contentSize = imageSize
                let targetOffset = CGPoint(
                    x: max(0, (imageSize.width - kScreenWidth) / 2),
                    y: 0
                )
                self.scrollView.setContentOffset(targetOffset, animated: true)
            }
        }
    }
    
    @objc func hiddenPhoto() {
        showTopViewAnimation()
        UIView.animate(withDuration: 0.25) {
            self.scrollView.transform = .identity
        } completion: { _ in
            self.scrollView.transform = CGAffineTransform(scaleX: 0, y: 0)
            self.scrollView.isHidden = true
            self.tableView.isHidden = false
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource[indexPath.row]
        guard item.type == .img else { return }
        showPhoto(imageUrl: item.imageUrl)
    }
}
