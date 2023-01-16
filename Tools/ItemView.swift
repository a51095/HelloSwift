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
        self.setUI()
    }
    
    // MARK: - UI初始化
    private func setUI() {
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
        topLabel.font = RegularFont(16)
        topLabel.textAlignment = .center
        topView.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
    
    func reloadCell(title: String) { topLabel.text = title }
}

class ItemView: UIView {
    /// 选中项(默认为1)
    var defaultSel: Int = 1
    /// 菜谱类型数据源
    private var dataSource = [String]()
    var didSeletedBlock: ((String) -> Void)?
    
    private var flowLayout = UICollectionViewFlowLayout()
    private var disPlayCollectionView: UICollectionView!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        self.initData()
    }
    
    override func layoutSubviews() {
        flowLayout.itemSize = CGSize(width: 100, height: frame.height)
    }
    
    // MARK: - 获取菜品种类
    private func getMenu() {
        NetworkRequest(url: AppURL.typefreeUrl) { res in
            // 容错处理
            guard res.data != nil else { return }
            
            if let dic = res.data {
                let datas = dic["datas"] as! [[String: Any]]
                for (item) in datas {
                    self.dataSource.append(contentsOf: item.keys)
                }
                self.didSeletedBlock?(self.dataSource[self.defaultSel])
                self.disPlayCollectionView.reloadData()
                self.disPlayCollectionView.selectItem(at: IndexPath(row: self.defaultSel, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            }
        }
    }
    
    // MARK: - 数据初始化
    private func initData() {
        getMenu()
    }
    
    // MARK: - 视图初始化
    private func setUI() {
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
    
    // MARK: - 移动到点击的indexPath
    private func scrollToItem(at indexPath: IndexPath) {
        disPlayCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension ItemView: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: - collectionView代理方法
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.classString, for: indexPath) as! ItemCell
        let string = dataSource[indexPath.item]
        cell.reloadCell(title: string)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSeletedBlock?(dataSource[indexPath.item])
        scrollToItem(at: indexPath)
    }
}
