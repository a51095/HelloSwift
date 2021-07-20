//
//  CCItemView.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/20.
//

import UIKit

fileprivate class ItemCell: UICollectionViewCell {
    private let topLabel = UILabel()
    private let bottomView = UIView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 反初始化器
    deinit { print("ItemCell deinit~") }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
    }
    
    // MARK: - UI初始化
    private func setUI() {
        addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.left.right.bottom.equalToSuperview()
        }
        
        let topView = UIView()
        addSubview(topView)
        topView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        topLabel.textColor = .gray
        topLabel.font = RegularFont(16)
        topLabel.textAlignment = .center
        topView.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.width.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - 监听用户点击index,继而改变状态
    override var isSelected: Bool {
        willSet {
            guard newValue != isSelected else { return }
            if newValue {
                topLabel.textColor = .main
                bottomView.backgroundColor = .main
            }else {
                topLabel.textColor = .gray
                bottomView.backgroundColor = .clear
            }
        }
    }
    
    /// 重置UI,渲染cell内容
    public func configCell(title: String) { topLabel.text = title }
}

class CCItemView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    /// 数据源
    private var dataSource = [String]()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initData()
        self.setUI()
    }
    
    // MARK: - 数据初始化
    func initData() {
        dataSource = ["关注","推荐","热榜","后端","精选","前端","热门","吃喝","玩乐","iOS","Android"]
        disPlayCollectionView.selectItem(at: IndexPath(row: 1, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    // MARK: - UI初始化
    func setUI() {
        addSubview(disPlayCollectionView)
        disPlayCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private lazy var disPlayCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 80, height: 60) // height不能高于父类height
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.classString())
        
        return collectionView
    }()
    
    // MARK: - collectionView代理方法
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.classString(), for: indexPath) as! ItemCell
        let string = dataSource[indexPath.item]
        cell.configCell(title: string)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scrollToItem(at: indexPath)
    }
    
    // MARK: - 移动到点击的indexPath
    private func scrollToItem(at indexPath: IndexPath) {
        disPlayCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
