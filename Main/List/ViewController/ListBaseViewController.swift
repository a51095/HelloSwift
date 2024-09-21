//
//  ListBaseViewController.swift
//  HelloSwift
//
//  Created by well on 2024/9/15.
//

import Foundation
import JXSegmentedView

enum Categories: String, CaseIterable {
    case top
    case guonei
    case guoji
    case yule
    case tiyu
    case junshi
    case keji
    case caijing
    case youxi
    case qiche
    case jiankang
    
    var title: String {
        switch self {
            case .top: "推荐"
            case .guonei: "国内"
            case .guoji: "国际"
            case .yule: "娱乐"
            case .tiyu: "体育"
            case .junshi: "军事"
            case .keji: "科技"
            case .caijing: "财经"
            case .youxi: "游戏"
            case .qiche: "汽车"
            case .jiankang: "健康"
        }
    }
}

class ListBaseViewController: BaseViewController {
    /// 子控制器
    private var controllers = [ListViewController]()
    var segmentedDataSource: JXSegmentedTitleDataSource!
    var segmentedView: JXSegmentedView!
    var listContainerView: JXSegmentedListContainerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSubview()
        self.initData()
    }
    
    override func initSubview() {
        
        // 初始化JXSegmentedView
        segmentedView = JXSegmentedView()
        view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kStatusBarHeight)
        }
        
        // 配置数据源
        segmentedDataSource = JXSegmentedTitleDataSource()
        segmentedDataSource.titles = Categories.allCases.map({ $0.title })
        segmentedDataSource.isTitleColorGradientEnabled = true
        segmentedView.dataSource = segmentedDataSource
        
        // 配置指示器
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.lineStyle = .lengthen
        segmentedView.indicators = [indicator]
        
        // 初始化JXSegmentedListContainerView
        listContainerView = JXSegmentedListContainerView(dataSource: self)
        view.addSubview(listContainerView)
        listContainerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(segmentedView.snp.bottom)
        }
        
        // 将listContainerView.scrollView和segmentedView.contentScrollView进行关联
        segmentedView.listContainer = listContainerView
    }
    
    override func initData() {
        for idx in Categories.allCases.indices {
            let vc = ListViewController()
            vc.newType = Categories.allCases[idx].rawValue
            controllers.append(vc)
        }
        
        segmentedView.defaultSelectedIndex = 1
        segmentedView.reloadData()
    }
}

extension ListBaseViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        segmentedDataSource.dataSource.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        controllers[index]
    }
}
