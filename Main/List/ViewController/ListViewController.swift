//
//  ListViewController.swift
//  HelloSwift
//
//  Created by well on 2023/3/12.
//

import UIKit
import SwiftyJSON
import Foundation
import JXPagingView

class ListViewController: BaseViewController {
    /// 当前显示新闻类型
    var newType = String()
    /// 是否下拉刷新
    var isNeedHeader = true
    /// 是否上拉加载更多
    var isNeedFooter = true
    
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
    
    override func initData() {
        getNewData(type: newType)
        
        if isNeedHeader {
            listTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefresh))
        }
        
        if isNeedFooter {
            listTableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        }
    }
    
    override func initSubview() {
        view.addSubview(listTableView)
        listTableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    // 下拉刷新
    @objc func headerRefresh() {
        getNewData(type: newType)
    }
    
    // 上拉加载更多
    @objc func loadMore() {
        getNewData(type: newType, isMore: true)
    }
    
    private func reloadDataIfNeed() {
        guard !listSource.isEmpty else { return }
        self.listTableView.reloadData()
    }
    
    // 获取新闻数据
    func getNewData(type: String, isMore: Bool = false, isFilter: Int = 1, pageSize: Int = 20) {
        
        var pageSize = pageSize
        
        if isMore {
            pageSize += 20
        }
        
        let parameters: [String: Any] = ["is_filter": isFilter, "page_size": pageSize, "type": type, "key": AppKey.newsKey]
        
        NetworkRequest(url: AppURL.toutiaoUrl, parameters: parameters) { res in
            self.listTableView.mj_header?.endRefreshing()
            self.listTableView.mj_footer?.endRefreshing()
            
            // 容错处理
            guard res != nil else { return }
            
            if let dictionary = res as? [String: Any] {
                let errorCode = dictionary["error_code"] as! Int
                guard errorCode == 0 else { self.listTableView.toast("暂无数据", type: .failure); return }
                
                // 先移除数据源，再添加新的数据源
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

extension ListViewController: JXPagingViewListViewDelegate {
    func listView() -> UIView {
        self.view
    }
    
    func listScrollView() -> UIScrollView {
        listTableView
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> Void) {
        
    }
}
