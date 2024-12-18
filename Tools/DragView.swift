//
//  DragView.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/15.
//

/**
 * DragView
 * 悬浮可拖动视图
 * 使用方法,
 * 直接初始化DragView视图,
 * 添加到父视图上,
 * 使用frame方式布局
 **/

final class DragView: UIView {
	/// 限制间距,默认设4个单位(预留可点击区域)
	private var limitMargin: CGFloat = 4
	private lazy var contentView = UIView()
	private lazy var imageView: UIImageView = {
		let i = UIImageView()
		i.isUserInteractionEnabled = true
		i.image = UIImage(named: "cartoon")
		return i
	}()

	public var didSelectBlock: os_block_t?

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	/// 反初始化器
	deinit {
		kPrint("DragView deinit")
	}

	/// 初始化器
	init(margin: CGFloat = 4.0, subview: UIView? = nil) {
		super.init(frame: .zero)
		limitMargin = margin
		if let s = subview { contentView = s }
		initSubview()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		contentView.frame = bounds
		imageView.frame = contentView.bounds
		addSubview(contentView)
		contentView.addSubview(imageView)
	}

	/// 子视图初始化
	private func initSubview() {
		// 点击手势
		let clickGesture = UITapGestureRecognizer(target: self, action: #selector(dragViewDidClick))
		// 拖拽手势
		let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(dragViewDidDrag(gesture:)))
		contentView.addGestureRecognizer(clickGesture)
		contentView.addGestureRecognizer(dragGesture)
	}

	/// 移除悬浮视图,并销毁定时器
	func removeDragView() {
		self.removeFromSuperview()
	}

	/// 展示悬浮按钮
	func showDragView() {
		UIView.animate(withDuration: 0.25) { self.transform = .identity }
	}

	/// 隐藏悬浮按钮
	func hiddenDragView() {
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

	/// dragView点击手势
	@objc private func dragViewDidClick() {
		// 隐藏悬浮按钮
		hiddenDragView()
		didSelectBlock?()
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			self.showDragView()
		}
	}

	/// dragView拖拽手势
	@objc private func dragViewDidDrag(gesture: UIPanGestureRecognizer) {
		// 移动状态
		let moveState = gesture.state
		switch moveState {
			case .changed:
				// 移动过程中,获取移动轨迹,重置center坐标点
				let point = gesture.translation(in: self.superview)
				self.center = CGPoint(x: self.center.x + point.x, y: self.center.y + point.y)
			case .ended:
				// 移动结束后,相关逻辑处理,重置center坐标点
				let point = gesture.translation(in: self.superview)
				let newPoint = CGPoint(x: self.center.x + point.x, y: self.center.y + point.y)

				// 自动吸边动画
				UIView.animate(withDuration: 0.1) {
					self.center = self.resetPosition(point: newPoint)
				}
			default: break
		}
		// 重置 panGesture
		gesture.setTranslation(.zero, in: self.superview!)
	}

	/// 更新中心点位置
	private func resetPosition(point: CGPoint) -> CGPoint {
		var newPoint = point

		// 靠左吸边
		if point.x <= (self.superview!.frame.width / 2) {
			// x轴偏右limitMargin个单位(预留可点击区域)
			newPoint.x = (self.frame.width / 2) + limitMargin
			// y轴偏下移10个单位(预留可点击区域)
			if point.y <= kSafeMarginTop { newPoint.y = kSafeMarginTop }
			// y轴偏上移10个单位(预留可点击区域)
			if point.y >= self.superview!.frame.height - (self.frame.height / 2) - kSafeMarginBottom {
				newPoint.y = self.superview!.frame.height - (self.frame.height / 2) - kSafeMarginBottom
			}
			return newPoint
		} else {
			// x轴偏左移limitMargin个单位(预留可点击区域)
			newPoint.x = self.superview!.frame.width - (self.frame.width / 2) - limitMargin
			// y轴偏下移10个单位(预留可点击区域)
			if point.y <= kSafeMarginTop { newPoint.y = kSafeMarginTop }
			// y轴偏上移10个单位(预留可点击区域)
			if point.y >= self.superview!.frame.height - (self.frame.height / 2) - kSafeMarginBottom {
				newPoint.y = self.superview!.frame.height - (self.frame.height / 2) - kSafeMarginBottom
			}
			return newPoint
		}
	}
}
