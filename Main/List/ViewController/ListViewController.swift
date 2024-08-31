//
//  ListViewController.swift
//  HelloSwift
//
//  Created by well on 2023/3/12.
//

import UIKit
import SwiftyJSON
import Foundation

class ListViewController: BaseViewController {
    /// 当前显示新闻类型
    private var currentNewsType = "guonei"
    /// 新闻数据源
    private var listSource = [ListModel]()
    /// 懒加载,新闻列表控件
    private lazy var listTableView: UITableView = {
        let v = UITableView()
        v.rowHeight = 120
        v.delegate = self
        v.dataSource = self
        v.separatorStyle = .none
        v.alwaysBounceVertical = false
        v.register(ListCell.self, forCellReuseIdentifier: ListCell.classString)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSubview()
        self.initData()
    }
    
    override func initData() { self.getNewsData(type: self.currentNewsType) }
    
    override func initSubview() {
        // 网络校验,有网则执行后续操作,网络不可用,则直接返回
        guard isReachable else { return }
        
        let topView = ItemView()
        topView.didSelectBlock = { type in
            self.currentNewsType = type
            self.getNewsData(type: type)
        }
        
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kStatusBarHeight)
        }
        
        view.addSubview(listTableView)
        listTableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        // 添加头部刷新
        let header = MJRefreshNormalHeader { self.downRefreshing() }
        header.setTitle("下拉刷新", for: .idle)
        header.setTitle("松开刷新", for: .pulling)
        header.setTitle("正在刷新", for: .refreshing)
        listTableView.mj_header = header
    }
    
    // 下拉刷新数据
    func downRefreshing() {
        self.getNewsData(type: self.currentNewsType)
    }
    
    private func reloadDataIfNeed() {
        guard !listSource.isEmpty else { return }
        self.listTableView.reloadData()
    }
    
    /// 获取新闻数据
    func getNewsData(type: String, isFilter: Int = 1, pageSize: Int = 20) {
        
        let parameters: [String: Any] = ["is_filter": isFilter, "page_size": pageSize, "type": type, "key": AppKey.newsKey]
        
        NetworkRequest(url: AppURL.toutiaoUrl, parameters: parameters) { res in
            self.listTableView.mj_header?.endRefreshing()
            // 容错处理
            guard res != nil else { return }
            
            if let dictionary = res as? [String: Any] {
                let errorCode = dictionary["error_code"] as! Int
                guard errorCode == 0 else { self.listTableView.toast("暂无数据", type: .failure); return }
                
                // 先移除上一个数据源，再添加新的数据源
                self.listSource.removeAll()
                
                let json = JSON(dictionary)
                let models = DataModel(jsonData: json).data.map {
                    ListModel(jsonData: $0)
                }.filter {
                    $0.thumbnail_pic_s.count > 0
                }
                self.listSource.append(contentsOf: models)
                self.reloadDataIfNeed()
            }
        }
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: ListCell.self, for: indexPath)
        let item = listSource[indexPath.row]
        cell.reloadCell(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = listSource[indexPath.row]
        let vc = ListDetailViewController(uniquekey: item.uniquekey)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
