class HomeViewController: BaseViewController {
    private lazy var listTableView: UITableView = {
        let v = UITableView()
        v.rowHeight = 60
        v.delegate = self
        v.dataSource = self
        v.separatorStyle = .none
        v.alwaysBounceVertical = false
        return v
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSubview()
    }
    
    override func initSubview() {
        view.addSubview(listTableView)
        listTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.topMargin)
            make.left.equalTo(self.view.snp.left)
            make.bottom.equalTo(self.view.snp.bottomMargin)
            make.right.equalTo(self.view.snp.right)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        Examples.all.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let examples = Examples.all[section]["examples"] as! [Example]
        return examples.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Examples.all[section]["title"] as? String
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let examples = Examples.all[indexPath.section]["examples"] as! [Example]
        let example = examples[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "exampleIdentifier")
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.text = example.title
        cell.detailTextLabel?.numberOfLines = 2
        cell.detailTextLabel?.textColor = .lightGray
        cell.detailTextLabel?.text = example.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let examples = Examples.all[indexPath.section]["examples"] as! [Example]
        let example = examples[indexPath.row]
        let exampleViewController = example.makeViewController()
        exampleViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(exampleViewController, animated: true)
    }
}
