//
//  CCDragView.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/15.
//

/**
 * CCDragView
 * 悬浮可拖动视图
 * 使用方法,直接初始化CCDragView视图,添加到父视图上,使用frame方式布局
 **/

final class CCDragView: UIView {
    /// 限制间距,默认设置2个单位(预留可点击区域)
    private let limitMargin: CGFloat = 2.0
    
    private var contentView = UIView()
    
    public var didSeletedBlock: os_block_t?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 反初始化器
    deinit {
        print("CCDragView deinit~")
    }
    
    // MARK: - 初始化器
    init() {
        super.init(frame: .zero)
        setUI()
    }
    
    // MARK: - UI初始化
    private func setUI() {
        // 点击手势
        let clickGesture = UITapGestureRecognizer(target: self, action: #selector(dragViewDidClick))
        // 拖拽手势
        let dragGesture = UIPanGestureRecognizer(target: self, action:#selector(dragViewDidDrag(gesture:)))
        contentView.addGestureRecognizer(clickGesture)
        contentView.addGestureRecognizer(dragGesture)
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - 主动移除悬浮视图并销毁定时器
    public func removeDragView() {
        self.removeFromSuperview()
    }
    
    // MARK: - 展示悬浮按钮
    public func showDragView() {
        UIView.animate(withDuration: 0.25) { self.transform = .identity }
    }
    
    // MARK: - 隐藏悬浮按钮
    public func hiddenDragView() {
        // 右位移距离
        var offSet = self.frame.width + limitMargin
        if self.center.x <= self.superview!.center.x {
            // 左位移距离
            offSet = -(self.frame.width + limitMargin)
        }
        // 位移动画
        UIView.animate(withDuration: 0.25) {
            self.transform = CGAffineTransform(translationX: offSet, y: 0)
        }
    }
    
    // MARK: - dragView点击手势
    @objc private func dragViewDidClick() {
        // 隐藏悬浮按钮
        hiddenDragView()
        didSeletedBlock?()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showDragView()
        }
    }
    
    // MARK: - dragView拖拽手势
    @objc private func dragViewDidDrag(gesture: UIPanGestureRecognizer) {
        // 移动状态
        let moveState = gesture.state
        switch moveState {
        case .changed:
            // 移动过程中,获取移动轨迹,重置center坐标点
            let point = gesture.translation(in: self.superview)
            self.center = CGPoint(x: self.center.x + point.x, y: self.center.y + point.y)
            break
        case .ended:
            // 移动结束后,相关逻辑处理,重置center坐标点
            let point = gesture.translation(in: self.superview)
            let newPoint = CGPoint(x: self.center.x + point.x, y: self.center.y + point.y)
            
            // 自动吸边动画
            UIView.animate(withDuration: 0.1) {
                self.center = self.resetPosition(point: newPoint)
            }
            break
        default: break
        }
        // 重置 panGesture
        gesture.setTranslation(.zero, in: self.superview!)
    }
    
    // MARK: - 更新中心点位置
    private func resetPosition(point: CGPoint) -> CGPoint {
        var newPoint = point
        
        // 靠左吸边
        if point.x <= (self.superview!.frame.width / 2) {
            // x轴偏右移2个单位(预留可点击区域)
            newPoint.x = (self.frame.width / 2) + limitMargin
            // y轴偏下移10个单位(预留可点击区域)
            if point.y <= kSafeMarginTop(20).cgf { newPoint.y = kSafeMarginTop(40).cgf }
            // y轴偏上移10个单位(预留可点击区域)
            if point.y >= self.superview!.frame.height - (self.frame.height / 2) - kSafeMarginBottom(20).cgf {
                newPoint.y = self.superview!.frame.height - (self.frame.height / 2) - kSafeMarginBottom(10).cgf
            }
            return newPoint
        }else {
            // x轴偏左移2个单位(预留可点击区域)
            newPoint.x = self.superview!.frame.width - (self.frame.width / 2) - limitMargin
            // y轴偏下移10个单位(预留可点击区域)
            if point.y <= kSafeMarginTop(20).cgf { newPoint.y = kSafeMarginTop(40).cgf }
            // y轴偏上移10个单位(预留可点击区域)
            if point.y >= self.superview!.frame.height - (self.frame.height / 2) - kSafeMarginBottom(20).cgf {
                newPoint.y = self.superview!.frame.height - (self.frame.height / 2) - kSafeMarginBottom(10).cgf
            }
            return newPoint
        }
    }
}
