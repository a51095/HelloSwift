//
//  CCHomeViewController.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/15.
//

import UIKit

class CCHomeViewController: CCViewController, UITableViewDelegate, UITableViewDataSource {
    /// 菜谱制作数据源
    private var menuSource = [MenuModel]()
    /// 懒加载,菜单列表控件
    lazy var menuTableView: UITableView = {
        let v = UITableView()
        v.rowHeight = 120
        v.delegate = self
        v.dataSource = self
        v.separatorStyle = .none
        v.alwaysBounceVertical = false
        v.register(MenuCell.self, forCellReuseIdentifier: MenuCell.classString())
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUI() {
        let topView = CCItemView()
        topView.didSeletedBlock = { (name) in
            self.cookingMethod(typeName: name)
        }
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.equalTo(MarginTop(0))
            make.height.equalTo(60)
            make.left.right.equalToSuperview()
        }
        
        view.addSubview(menuTableView)
        menuTableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    // MARK: - 菜品做法
    func cookingMethod(typeName: String) {
        menuSource.removeAll()
        view.showLoading()
        let param = ["uid": CCAppKeys.freeUid, "appkey": CCAppKeys.freeAppKey,"type": typeName]
        AF.request(CCAppURL.queryfreeURL, method: .post, parameters: param, encoding: URLEncoding.default).responseJSON { res in
            self.view.hideLoading()
            guard res.error == nil else { return }
            let dic = res.value as! [String: Any]
            let datas = dic["datas"] as! [[String: Any]]
            for item in datas {
                let model = MenuModel.deserialize(from: item)
                self.menuSource.append(model!)
            }
            self.menuTableView.reloadData()
        }
    }
    
    // MARK: - menuTableView代理方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.classString(), for: indexPath) as! MenuCell
        let item = menuSource[indexPath.row]
        cell.configCell(item: item)
        return cell
    }
}
