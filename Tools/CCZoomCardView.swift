//
//  CCZoomCardView.swift
//  HelloSwift
//
//  Created by well on 2021/9/26.
//

/**
 * CCZoomCardView
 * 左右滑动缩放视图
 * 继承于UIView,使用灵活
 **/

protocol CCZoomCardViewDelegate: NSObjectProtocol {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}

// 自定义flowLayout
class CCZoomCardCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool { true }
    
    override func prepare() {
        super.prepare()
        let margin = ((collectionView!.frame.width) - itemSize.width) / 2
        collectionView!.contentInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let superArray = super.layoutAttributesForElements(in: rect)
        let tempArray = NSArray(array: superArray!, copyItems: true) as! [UICollectionViewLayoutAttributes]
        let centerX = collectionView!.contentOffset.x + collectionView!.frame.size.width * 0.5
        for item  in tempArray.enumerated() {
            let distance = abs(item.element.center.x - centerX)
            let scale = 1 - distance / (collectionView?.frame.width)!
            item.element.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        return tempArray
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var contentOffset = proposedContentOffset
        let rect = CGRect(x: contentOffset.x, y: 0, width: collectionView!.frame.size.width, height: collectionView!.frame.size.height)
        let arr = super.layoutAttributesForElements(in: rect)
        let centerX: CGFloat = contentOffset.x + collectionView!.frame.size.width * 0.5
        var minDistance = CGFloat(MAXFLOAT)
        for item  in arr!.enumerated() {
            let distance = item.element.center.x - centerX
            if (abs(distance) < abs(minDistance)) {
                minDistance = distance
            }
        }
        contentOffset.x += minDistance
        return contentOffset
    }
}

class CCZoomCardView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    /// 代理对象
    weak var delegate: CCZoomCardViewDelegate?
    
    /// 懒加载flowLayout
    private lazy var flowLayout: CCZoomCardCollectionViewFlowLayout = {
        let layout = CCZoomCardCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }()
    
    /// 懒加载collectionView
    private lazy var collectionView: UICollectionView = {
        let c = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        c.delegate = self
        c.dataSource = self
        c.showsHorizontalScrollIndicator = false
        c.contentInsetAdjustmentBehavior = .never
        return c
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 反初始化器
    deinit { print("CCZoomCardView deinit!") }
    
    // MARK: - 初始化器
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setUI()
    }
    
    override func layoutSubviews() {
        flowLayout.itemSize = CGSize(width: self.frame.width * 0.6, height: self.frame.height * 0.6)
    }
    
    func setUI() {
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        (delegate?.collectionView(collectionView, numberOfItemsInSection: section))!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        (delegate?.collectionView(collectionView, cellForItemAt: indexPath))!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    // MARK: - 注册自定义cell
    func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
}
