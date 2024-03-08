//
//  ScaleAspectView.swift
//  HelloSwift
//
//  Created by well on 2021/9/2.
//

/**
 * ScaleAspectView
 * 下拉缩放视图
 * 继承于UIView,使用灵活
 **/

class ScaleAspectView: UIView {
    /// tableView返回count,默认10
    private let defaultCount = 10
    /// 图片高度,默认280
    private let defaultHeight = 280
    
    private var imageView = UIImageView()
    private var tableView = UITableView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 反初始化器
    deinit { kPrint("StretchingView deinit") }
    
    // MARK: 初始化器
    init() { super.init(frame: .zero) }
    
    override func draw(_ rect: CGRect) {
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: 0, width: Int(self.frame.width), height: Int(self.frame.size.height))
        
        let headView = UIView()
        tableView.tableHeaderView = headView
        headView.frame = CGRect(x: 0, y: 0, width: Int(self.frame.width), height: defaultHeight)
        
        headView.addSubview(imageView)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "aspect")
        imageView.frame = CGRect(x: 0, y: 0, width: Int(self.frame.width), height: defaultHeight)
    }
}

extension ScaleAspectView: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        defaultCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: classString)
        cell.textLabel?.text = "向下拉我"
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 这里的偏移量是纵向从contentInset算起,即一开始偏移量就是0,向下拉为负,上拉为正;
        let offSetY = Int(scrollView.contentOffset.y)
        if offSetY < 0 {
            imageView.frame = CGRect(x: 0, y: offSetY, width: Int(self.frame.width), height: defaultHeight - offSetY)
        }
    }
}
