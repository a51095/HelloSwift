//
//  ListBaseViewController.swift
//  HelloSwift
//
//  Created by well on 2024/9/15.
//

import Foundation
import SmartCodable
import JXPagingView
import JXSegmentedView

class ListBaseViewController: BaseViewController {
    /// 子控制器
    private var newsTypeArray = [NewsTypeModel]()
    /// 子控制器
    private var controllers = [ListViewController]()
    /// 整体滚动视图
    private lazy var pagingView: JXPagingView = {
        let pagingView = JXPagingView(delegate: self)
        pagingView.defaultSelectedIndex = 1
        pagingView.mainTableView.gestureDelegate = self
        return pagingView
    }()
    /// 自定义headView
    private lazy var headerView = ListTableHeaderView()
    /// JXSegmentedView悬浮视图
    private lazy var segmentedView: JXSegmentedView = {
        let segmentedView = JXSegmentedView()
        segmentedView.delegate = self
        segmentedView.indicators = [lineView]
        segmentedView.defaultSelectedIndex = 1
        segmentedView.dataSource = segmentedViewDataSource
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
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
        segmentedViewDataSource.isTitleColorGradientEnabled = true
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
        fetchRollNewsType()
    }
    
    private func fetchRollNewsType() {
        let url = AppURL.rollTypesUrl + "app_id=\(AppKey.rollAppKey)" + "&" + "app_secret=\(AppKey.rollSecretKey)"
        NetworkRequest(url: url, method: .get, responseType: .dictionary) {  res in
            // 容错处理
            guard res != nil else { return }
            
            if let dictionary = res as? [String: Any] {
                if let array = dictionary["data"] as? [[String: Any]] {
                    array.forEach { dict in
                        guard let model = NewsTypeModel.deserialize(from: dict) else { return }
                        self.newsTypeArray.append(model)
                        let vc = ListViewController()
                        vc.newTypeId = model.typeId
                        self.controllers.append(vc)
                    }
                }
                self.segmentedViewDataSource.titles = self.newsTypeArray.map({ $0.typeName })
                self.segmentedView.reloadData()
            }
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

extension ListBaseViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) { }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) { }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didScrollSelectedItemAt index: Int) { }
    
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) { }
}

extension ListBaseViewController: JXPagingMainTableViewGestureDelegate {
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
