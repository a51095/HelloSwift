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
    /// 请求页数
    private var page = 1
    /// 当前显示新闻类型
    var newTypeId = String()
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
        super.initData()
        
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 1) {
            self.fetchRollNewsList()
        }
        
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
        fetchRollNewsList()
    }
    
    // 上拉加载更多
    @objc func loadMore() {
        page += 1
        fetchRollNewsList()
    }
    
    private func reloadDataIfNeed() {
        guard !listSource.isEmpty else { return }
        self.listTableView.reloadData()
    }
    
    // 获取新闻数据
    private func fetchRollNewsList() {
        let url = AppURL.rollListUrl + "page=\(page)" + "&" + "typeId=\(newTypeId)" + "&" + "app_id=\(AppKey.rollAppKey)" + "&" + "app_secret=\(AppKey.rollSecretKey)"
        NetworkRequest(url: url, method: .get, responseType: .dictionary) { res in
            self.listTableView.mj_header?.endRefreshing()
            self.listTableView.mj_footer?.endRefreshing()
            
            // 容错处理
            guard res != nil else { return }
            
            if let dictionary = res as? [String: Any] {
                let json = JSON(dictionary)
                
                if json["code"].intValue == 101 {
                    return kTopViewController.view.toast("过于频繁,请稍后再试!", type: .failure)
                }
                
                guard json["code"].intValue == 1 else {
                    return kTopViewController.view.toast("暂无数据~", type: .failure)
                }
                
                // 若下拉刷新,则先移除数据源，再添加新的数据源
                if self.isNeedHeader {
                    self.listSource.removeAll()
                }
                
                json["data"].arrayValue.forEach { item in
                    if let images = item["imgList"].arrayObject as? [String] {
                        self.listSource.append(ListModel(title: item["title"].stringValue, postTime: item["postTime"].stringValue, newsId: item["newsId"].stringValue, imgList: images))
                    }
                }
                self.reloadDataIfNeed()
            }
        }
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: ListCell.self, for: indexPath)
        let item = listSource[indexPath.row]
        cell.reloadCell(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = listSource[indexPath.row]
        let vc = ListDetailViewController(newsId: item.newsId)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ListViewController: JXPagingViewListViewDelegate {
    func listView() -> UIView {
        return view
    }
    
    func listScrollView() -> UIScrollView {
        return listTableView
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> Void) { }
}
