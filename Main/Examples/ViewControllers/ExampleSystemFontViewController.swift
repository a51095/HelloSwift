//
//  ExampleSystemFontViewController.swift
//  HelloSwift
//
//  Created by well on 2024/9/15.
//

import Foundation

class ExampleSystemFontViewController: BaseViewController, ExampleProtocol {
    
    private lazy var fontTableView: UITableView = {
        let v = UITableView(frame: .zero, style: .grouped)
        v.rowHeight = 60
        v.delegate = self
        v.dataSource = self
        v.alwaysBounceVertical = false
        v.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.classString)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSubview()
    }
    
    override func initSubview() {
        super.initSubview()
        
        view.addSubview(fontTableView)
        fontTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: kSafeMarginTop, left: 0, bottom: 0, right: 0))
        }
    }
    
    private func loadFontFamilies() {
        let fontFamilies = UIFont.familyNames
        for familyName in fontFamilies {
            kPrint("Font Family: \(familyName)")
            let fontNames = UIFont.fontNames(forFamilyName: familyName)
            for name in fontNames {
                kPrint("fontName: \(name)")
            }
        }
    }
}

extension ExampleSystemFontViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        UIFont.familyNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let fontFamilie = UIFont.familyNames[section]
        return UIFont.fontNames(forFamilyName: fontFamilie).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.classString, for: indexPath)
        let fontFamilie = UIFont.familyNames[indexPath.section]
        let fontNames = UIFont.fontNames(forFamilyName: fontFamilie)
        let fontName = fontNames[indexPath.row]
        cell.textLabel?.text = fontNames[indexPath.row]
        cell.textLabel?.font = UIFont(name: fontName, size: 16)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fontFamilie = UIFont.familyNames[indexPath.section]
        let fontNames = UIFont.fontNames(forFamilyName: fontFamilie)
        UIPasteboard.general.string = fontNames[indexPath.row]
        view.toast("复制成功", type: .success)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let fontFamilies = UIFont.familyNames.sorted()
        let headerView = UIView()
        let titleLabel = UILabel()
        titleLabel.textColor = .main
        titleLabel.font = kMediumFont(14)
        titleLabel.text = fontFamilies[section]
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        CGFLOAT_MIN
    }
}
