//
//  CCHomeViewController.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/15.
//

import UIKit

class CCHomeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    /// 当前显示菜单类型
    private var currentIndexName = ""
    /// 菜谱制作数据源
    private var menuSource = [CCMenuModel]()
    /// 懒加载,菜单列表控件
    lazy var menuTableView: UITableView = {
        let v = UITableView()
        v.rowHeight = 120
        v.delegate = self
        v.dataSource = self
        v.separatorStyle = .none
        v.alwaysBounceVertical = false
        v.register(CCMenuCell.self, forCellReuseIdentifier: CCMenuCell.classString())
        return v
    }()
    
    override func setUI() {
        // 网络校验,有网则执行后续操作,网络不可用,则直接返回
        guard isReachable() else { return }
        
        let topView = CCItemView()
        topView.didSeletedBlock = { [weak self] (name) in
            guard let self = self else { return }
            self.menuSource.removeAll()
            self.currentIndexName = name
            self.cookingMethod(typeName: name)
        }
        
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.equalTo(kSafeMarginTop(0))
            make.height.equalTo(60)
            make.left.right.equalToSuperview()
        }
        
        view.addSubview(menuTableView)
        menuTableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        // 添加头部刷新
        let header = MJRefreshNormalHeader { self.downRefreshing() }
        header.setTitle("下拉刷新", for: .idle)
        header.setTitle("松开刷新", for: .pulling)
        header.setTitle("正在刷新", for: .refreshing)
        menuTableView.mj_header = header
        
        // 添加底部刷新
//        let footer = MJRefreshAutoNormalFooter { }
//        menuTableView.mj_footer = footer
    }
    
    // 下拉刷新数据
    func downRefreshing() {
        self.cookingMethod(typeName: self.currentIndexName)
    }
    
    // MARK: - 菜品做法
    func cookingMethod(typeName: String) {
        // 先从单例中获取数据,有则直接读取展示,反之请求更新
        if let data = CCMenuManager.shared.checkSources(nameKey: typeName) {
            menuSource = data
            menuTableView.mj_header?.endRefreshing()
            menuTableView.reloadData()
            return
        }
        
        NetworkRequest(url: CCAppURL.queryfreeUrl, parameters: ["type": typeName]) { res in
            self.menuTableView.mj_header?.endRefreshing()
            // 容错处理
            guard res.resCode != nil else { return }
            
            if let dic = res.data {
                let datas = dic["datas"] as! [[String: Any]]
                for item in datas {
                    let model = CCMenuModel.deserialize(from: item)
                    self.menuSource.append(model!)
                }
                self.menuTableView.reloadData()
                CCMenuManager.shared.updateMenuDic(nameKey: typeName, value: self.menuSource)
            }
        }
    }
    
    // MARK: - menuTableView代理方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CCMenuCell.classString(), for: indexPath) as! CCMenuCell
        let item = menuSource[indexPath.row]
        cell.configCell(item: item)
        return cell
    }
}
