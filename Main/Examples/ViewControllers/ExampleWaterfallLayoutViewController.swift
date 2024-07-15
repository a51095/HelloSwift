import UIKit
import Foundation
import SwiftyJSON

struct LargeModel {
    var large: String
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
    
    func reloadCell(item: LargeModel) {
        photoImageView.kf.indicatorType = .activity
        photoImageView.kf.setImage(with: URL(string: item.large), placeholder: UIImage(named: "placeholder_list_cell_img"))
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
    private var dataSource = [LargeModel]()
    
    private lazy var collectionView: UICollectionView = {
        let layout = WaterfallLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
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
        self.collectionView.reloadData()
        currentPage += 1
    }
    
    private func fetchPhotos() {
        let headers: HTTPHeaders = ["Authorization": AppKey.pexelsKey]
        let parameters: [String: Any] = ["page": currentPage, "per_page": 20]
        NetworkRequest(url: AppURL.photosUrl, headers: headers, parameters: parameters) { res in
            if let dictionary = res as? [String: Any] {
                let json = JSON(dictionary)
                let arrayUrls =  json["photos"].arrayValue.map { LargeModel(large: $0["src"]["large"].stringValue) }
                self.dataSource.append(contentsOf: arrayUrls)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if currentOffsetY > maximumOffset - scrollView.contentInset.bottom { fetchPhotos() }
        
        if currentOffsetY > topView.frame.size.height {
            if !isTopViewHidden {
                isTopViewHidden = true
                UIView.animate(withDuration: 0.25, animations: {
                    self.topView.alpha = 0.5
                }, completion: { _ in
                    UIView.animate(withDuration: 0.25) {
                        self.topView.alpha = 0
                        self.backButton.isHidden = true
                        self.topView.transform = CGAffineTransform(translationX: 0, y: -80)
                    }
                })
            }
        } else {
            if isTopViewHidden {
                isTopViewHidden = false
                UIView.animate(withDuration: 0.25, animations: {
                    self.topView.alpha = 0.5
                }, completion: { _ in
                    UIView.animate(withDuration: 0.25) {
                        self.topView.alpha = 1
                        self.backButton.isHidden = false
                        self.topView.transform = .identity
                    }
                })
            }
        }
    }
}
