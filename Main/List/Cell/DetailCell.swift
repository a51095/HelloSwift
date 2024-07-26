import UIKit
import WebKit
import Foundation
import Kingfisher

class DetailCell: UITableViewCell {
    /// 新闻详情
    private var webView = WKWebView()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initSubview()
    }

    /// 子视图初始化
    private func initSubview() {
        selectionStyle = .none
        contentView.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.right.equalToSuperview().offset(-20)
        }
    }

    func reloadCell(item: DetailModel) {
        guard let content = item.content else { return }
        webView.loadHTMLString(content, baseURL: nil)
    }
}

class DetailHeadView: UIView, UIScrollViewDelegate {
    /// 资源图片
    private var resources: [String]
    /// pageControl
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .orange
        return pageControl
    }()
    
    init(resources: [String]) {
        self.resources = resources
        super.init(frame: .zero)
        initSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubView() {
        let scrollView = UIScrollView()
        addSubview(scrollView)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentSize = CGSize(width: kScreenWidth * resources.count, height: 0)
        scrollView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: bounds.height.i)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        var viewArray = [UIImageView]()
        for url in resources {
            let imageView =  createImageView(url: url)
            viewArray.append(imageView)
        }
        
        let stackView = UIStackView(arrangedSubviews: viewArray)
        scrollView.addSubview(stackView)
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.frame = CGRect(x: 0, y: 0, width: kScreenWidth * resources.count, height: bounds.height.i)
        
        guard resources.count > 1 else { return }
        
        addSubview(pageControl)
        pageControl.numberOfPages = resources.count
        pageControl.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    private func createImageView(url: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: url), placeholder: UIImage(named: "placeholder"))
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = scrollView.contentOffset.x.i / kScreenWidth
        guard currentIndex != pageControl.currentPage else { return }
        pageControl.currentPage = currentIndex
    }
}
