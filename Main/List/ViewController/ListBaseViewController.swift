//
//  ListBaseViewController.swift
//  HelloSwift
//
//  Created by well on 2024/9/15.
//

import Foundation
import JXPagingView
import JXCategoryView

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
    
    /// 懒加载 JXPagerView
    private lazy var pagerView: JXPagingView = {
        let pagerView = JXPagingView(delegate: self)
        pagerView.mainTableView.gestureDelegate = self
        pagerView.pinSectionHeaderVerticalOffset = 0
        pagerView.automaticallyDisplayListVerticalScrollIndicator = false
        return pagerView
    }()
    
    /// 懒加载 JXCategoryTitleView
    private lazy var categoryView: JXCategoryTitleView = {
        let categoryView = JXCategoryTitleView()
        categoryView.titles = Categories.allCases.map { $0.title }
        categoryView.delegate = self
        categoryView.titleColor = .gray
        categoryView.titleSelectedColor = .main
        categoryView.titleLabelVerticalOffset = -3
        categoryView.titleFont = kRegularFont(16)
        categoryView.titleSelectedFont = kMediumFont(16)
        categoryView.isTitleColorGradientEnabled = true
        return categoryView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSubview()
        self.initData()
    }
    
    override func initSubview() {
        
        view.addSubview(pagerView)
        pagerView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: kStatusBarHeight, left: 0, bottom: 0, right: 0))
        }
        
        let lineView = JXCategoryIndicatorLineView()
        lineView.verticalMargin = 14
        lineView.indicatorWidth = 20
        lineView.indicatorHeight = 2
        lineView.indicatorColor = .main
        lineView.indicatorCornerRadius = 1
        
        categoryView.indicators = [lineView]
        categoryView.listContainer = pagerView.listContainerView as? JXCategoryViewListContainer
    }
    
    override func initData() {
        for (idx, ele) in Categories.allCases.enumerated() {
            let vc = ListViewController()
            vc.currentNewsType = Categories.allCases[idx].rawValue
            controllers .append(vc)
        }
    }
}

extension ListBaseViewController: JXPagingViewDelegate, JXCategoryViewDelegate, JXPagingMainTableViewGestureDelegate {
    
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        200
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        let tableHeaderView = UILabel()
        tableHeaderView.text = "敬请期待"
        tableHeaderView.textColor = .white
        tableHeaderView.font = kSemiblodFont(28)
        tableHeaderView.textAlignment = .center
        tableHeaderView.backgroundColor = .main
        return tableHeaderView
    }
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        60
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        categoryView
    }
    
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        categoryView.titles.count
    }
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        controllers[index]
    }
    
    func categoryView(_ categoryView: JXCategoryBaseView!, didSelectedItemAt index: Int) {
        controllers[index].currentNewsType = Categories.allCases[index].rawValue
        pagerView.mainTableView.reloadData()
    }
    
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        false
    }
}
