//
//  ExampleSymbolViewController.swift
//  HelloSwift
//
//  Created by neusoft on 2024/4/9.
//

import Foundation

class ExampleSymbolViewController: BaseViewController, ExampleProtocol {
    private(set) var symbols: [String] = []
    private var iconImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSubview()
        self.loadSymbols()
        self.randomIcon()
    }

    func randomIcon() {
        if #available(iOS 13.0, *) {
            let randomImage = UIImage(systemName: symbols.randomElement() ?? "")
            let config = UIImage.SymbolConfiguration(weight: .bold)
            let modified = randomImage?.applyingSymbolConfiguration(config)
            let coloredImage = modified?.withTintColor(UIColor.lightGray, renderingMode: .alwaysOriginal)
            iconImageView.image = coloredImage
            iconImageView.contentMode = .scaleAspectFit
        }
    }

    override func initSubview() {
        super.initSubview()

        let button = UIButton()
        button.backgroundColor = .orange
        button.setTitle("随机图片", for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didSelect), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.centerY.equalToSuperview()
            make.left.equalTo(view.snp_leftMargin).offset(20)
            make.right.equalTo(view.snp_rightMargin).offset(-20)
        }

        view.addSubview(iconImageView)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 100))
            make.bottom.equalTo(button.snp_topMargin).offset(-20)
        }
    }

    @objc func didSelect(button: UIButton) {
        randomIcon()
    }

    private func loadSymbols() {
        guard let bundle = Bundle(identifier: "com.apple.CoreGlyphs"),
              let url = bundle.url(forResource: "symbol_search", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let values = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: [String]]
        else {
            print("Failed to load symbol search data from the CoreGlyphs bundle.")
            return
        }
        symbols = Array(values.keys)
    }
}
