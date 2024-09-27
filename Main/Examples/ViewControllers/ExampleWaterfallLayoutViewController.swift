import UIKit
import SmartCodable
import Foundation

struct UnsplashModel: SmartCodable {
    var full = String()
    var thumb = String()
    var regular = String()
    
    static func mappingForKey() -> [SmartKeyTransformer]? {
        [
            CodingKeys.full <--- "urls.full",
            CodingKeys.thumb <--- "urls.thumb",
            CodingKeys.regular <--- "urls.regular"
        ]
    }
}

class WaterfallLayoutCell: UICollectionViewCell {
    var photoImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(photoImageView)
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadCell(item: UnsplashModel) {
        photoImageView.kf.indicatorType = .activity
        photoImageView.kf.setImage(with: URL(string: item.regular), placeholder: UIImage(named: "placeholder"))
    }
}

class WaterfallLayout: UICollectionViewLayout {
    private var numberOfColumns = 2
    private var cellPadding: CGFloat = 6
    private var contentHeight: CGFloat = 0
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView?.bounds.width ?? 0, height: contentHeight)
    }
    
    override func prepare() {
        guard let collectionView = collectionView else { return }
        
        cache.removeAll()
        
        let totalWidth = collectionView.bounds.width
        let columnWidth = (totalWidth - (CGFloat(numberOfColumns + 1) * cellPadding)) / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * (columnWidth + cellPadding) + cellPadding)
        }
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let photoHeight = CGFloat.random(in: 100..<250)
            let height = cellPadding * 2 + photoHeight
            let minYOffset = yOffset.min() ?? 0
            let column = yOffset.firstIndex(of: minYOffset) ?? 0
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] += height
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}

class ExampleWaterfallLayoutViewController: BaseViewController, ExampleProtocol {
    
    private var currentPage = 1
    private var isTopViewHidden = false
    private var dataSource = [UnsplashModel]()
    
    private lazy var collectionView: UICollectionView = {
        let layout = WaterfallLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WaterfallLayoutCell.self, forCellWithReuseIdentifier: WaterfallLayoutCell.classString)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSubview()
        self.fetchPhotos()
    }
    
    override func initSubview() {
        super.initSubview()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp_bottomMargin)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    private func reloadDataIfNeed() {
        guard !dataSource.isEmpty else { return }
        collectionView.reloadData()
        currentPage += 1
    }
    
    private func fetchPhotos() {
        let parameters: [String: Any] = ["client_id": AppKey.unsplashKey, "page": currentPage, "per_page": 20]
        NetworkRequest(url: AppURL.photosUrl, method: .get, parameters: parameters, showErrorMsg: true, encoding: URLEncoding.default, responseType: .array) { res in
            if let array = res as? [[String: Any]] {
                array.forEach { dict in
                    guard let model = UnsplashModel.deserialize(from: dict) else { return }
                    self.dataSource.append(model)
                }
                self.reloadDataIfNeed()
            }
        }
    }
}

extension ExampleWaterfallLayoutViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WaterfallLayoutCell.classString, for: indexPath) as! WaterfallLayoutCell
        let model = dataSource[indexPath.item]
        cell.reloadCell(item: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource[indexPath.item]
        let vc = ExampleUnsplashDetailViewController(model: model)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        (currentOffsetY > topView.frame.size.height) ? hideTopViewAnimation() : showTopViewAnimation()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if currentOffsetY > (maximumOffset - scrollView.contentInset.bottom) { fetchPhotos() }
    }
}
