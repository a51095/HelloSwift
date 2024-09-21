//
//  ListBaseViewController.swift
//  HelloSwift
//
//  Created by well on 2024/9/15.
//

import Foundation
import JXPagingView
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
    /// 整体滚动视图
    private lazy var pagingView: JXPagingView = {
        let pagingView = JXPagingView(delegate: self)
        pagingView.defaultSelectedIndex = 1
        return pagingView
    }()
    /// 自定义headView
    private lazy var headerView = ListTableHeaderView()
    /// JXSegmentedView悬浮视图
    private lazy var segmentedView: JXSegmentedView = {
        let segmentedView = JXSegmentedView()
        segmentedView.indicators = [lineView]
        segmentedView.defaultSelectedIndex = 1
        segmentedView.dataSource = segmentedViewDataSource
        segmentedView.listContainer = pagingView.listContainerView
        return segmentedView
    }()
    /// 悬浮视图滚动条
    private lazy var lineView: JXSegmentedIndicatorLineView = {
        let lineView = JXSegmentedIndicatorLineView()
        return lineView
    }()
    /// 悬浮视图类型
    private lazy var segmentedViewDataSource: JXSegmentedTitleDataSource = {
        let segmentedViewDataSource = JXSegmentedTitleDataSource()
        segmentedViewDataSource.titles = Categories.allCases.map({ $0.title })
        return segmentedViewDataSource
    }()
    
    private var headerViewHeight: Int = 200
    private var heightForHeaderInSection: Int = 60
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSubview()
        self.initData()
    }
    
    override func initSubview() {
        view.addSubview(pagingView)
        pagingView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kStatusBarHeight)
        }
    }
    
    override func initData() {
        for idx in Categories.allCases.indices {
            let vc = ListViewController()
            vc.newType = Categories.allCases[idx].rawValue
            controllers.append(vc)
        }
    }
}

extension JXPagingListContainerView: @retroactive JXSegmentedViewListContainer {}

extension ListBaseViewController: JXPagingViewDelegate {
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return headerViewHeight
    }

    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return headerView
    }

    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return heightForHeaderInSection
    }

    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return segmentedView
    }

    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return segmentedViewDataSource.titles.count
    }
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        return controllers[index]
    }

    func mainTableViewDidScroll(_ scrollView: UIScrollView) {
        headerView.scrollViewDidScroll(contentOffsetY: scrollView.contentOffset.y)
    }
}

extension ListBaseViewController: JXPagingMainTableViewGestureDelegate {
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer == segmentedView.collectionView.panGestureRecognizer {
            return false
        }
        return gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
    }
}
