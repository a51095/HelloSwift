import UIKit
import HandyJSON
import Foundation

struct PhotosModel: HandyJSON {
    var photos: [SrcModel]?
}

struct SrcModel: HandyJSON {
    var src: [String: Any]?
}

struct LargeModel: HandyJSON {
    var large: String?
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
        photoImageView.kf.setImage(with: URL(string: item.large!), placeholder: UIImage(named: "placeholder_list_cell_img"))
    }
}

class WaterfallLayout: UICollectionViewLayout {
    private var numberOfColumns = 2
    private var cellPadding: CGFloat = 6
    private var contentHeight: CGFloat = 0
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView!.bounds.width, height: contentHeight)
    }
    
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        cache.removeAll()
        
        let columnWidth = collectionView.bounds.width / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        var column = 0
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let photoHeight = CGFloat.random(in: 100..<250)
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] += height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}

class ExampleWaterfallLayoutViewController: BaseViewController, ExampleProtocol {
    
    var dataSource = [LargeModel]()
    var currentPage = 1
    
    lazy var collectionView: UICollectionView = {
        let layout = WaterfallLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(WaterfallLayoutCell.self, forCellWithReuseIdentifier: WaterfallLayoutCell.classString)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        self.initSubview()
        self.fetchPhotos()
    }
    
    override func initSubview() {
        super.initSubview()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kSafeMarginTop(44))
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
                if let model = PhotosModel.deserialize(from: dictionary) {
                    
                    if let photos = model.photos {
                        for photo in photos {
                            if let largeUrl = photo.src?["large"] as? String {
                                let largeModel = LargeModel(large: largeUrl)
                                self.dataSource.append(largeModel)
                                self.reloadDataIfNeed()
                            }
                        }
                    }
                }
            }
        }
    }
}

extension ExampleWaterfallLayoutViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WaterfallLayoutCell.classString, for: indexPath) as! WaterfallLayoutCell
        let model = dataSource[indexPath.item]
        cell.reloadCell(item: model)
        return cell
    }
}
