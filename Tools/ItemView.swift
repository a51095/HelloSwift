struct ItemModel {
    let name: String
    let type: String
}

class ItemCell: UICollectionViewCell {
    private let topLabel = UILabel()
    private let bottomView = UIView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 反初始化器
    deinit { kPrint("ItemCell deinit~") }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSubview()
    }
    
    /// 子视图初始化
    private func initSubview() {
        addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.width.equalTo(40)
            make.centerX.bottom.equalToSuperview()
        }
        
        let topView = UIView()
        addSubview(topView)
        topView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top).priority(999)
        }
        
        topLabel.textColor = .gray
        topLabel.font = kRegularFont(16)
        topLabel.textAlignment = .center
        topView.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// 监听用户点击index,继而改变状态
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
    
    func reloadCell(item: ItemModel) { topLabel.text = item.name }
}

class ItemView: UIView {
    /// 选中项(默认为1)
    var defaultSel: Int = 1
    /// 新闻类型数据源
    private var dataSource = [ItemModel]()
    var didSeletedBlock: ((String) -> Void)?
    
    private var flowLayout = UICollectionViewFlowLayout()
    private var disPlayCollectionView: UICollectionView!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSubview()
        self.initData()
    }
    
    override func layoutSubviews() {
        flowLayout.itemSize = CGSize(width: 60, height: frame.height)
    }
    
    /// 数据初始化
    private func initData() {
        self.dataSource.append(ItemModel(name: "推荐", type: "top"))
        self.dataSource.append(ItemModel(name: "国内", type: "guonei"))
        self.dataSource.append(ItemModel(name: "国际", type: "guoji"))
        self.dataSource.append(ItemModel(name: "娱乐", type: "yule"))
        self.dataSource.append(ItemModel(name: "体育", type: "tiyu"))
        self.dataSource.append(ItemModel(name: "军事", type: "junshi"))
        self.dataSource.append(ItemModel(name: "科技", type: "keji"))
        self.dataSource.append(ItemModel(name: "财经", type: "caijing"))
        self.dataSource.append(ItemModel(name: "游戏", type: "youxi"))
        self.dataSource.append(ItemModel(name: "汽车", type: "qiche"))
        self.dataSource.append(ItemModel(name: "健康", type: "jiankang"))
        self.disPlayCollectionView.reloadData()
        self.disPlayCollectionView.selectItem(at: IndexPath(row: self.defaultSel, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    /// 视图初始化
    private func initSubview() {
        backgroundColor = .white
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        
        disPlayCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        disPlayCollectionView.delegate = self
        disPlayCollectionView.dataSource = self
        disPlayCollectionView.backgroundColor = .clear
        disPlayCollectionView.showsHorizontalScrollIndicator = false
        disPlayCollectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.classString)
        addSubview(disPlayCollectionView)
        disPlayCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// 移动到点击的indexPath
    private func scrollToItem(at indexPath: IndexPath) {
        disPlayCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension ItemView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.classString, for: indexPath) as! ItemCell
        let item = dataSource[indexPath.item]
        cell.reloadCell(item: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSeletedBlock?(dataSource[indexPath.item].type)
        scrollToItem(at: indexPath)
    }
}
