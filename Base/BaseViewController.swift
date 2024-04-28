class BaseViewController: UIViewController, NetworkStatus, BaseProtocol {
    /// 懒加载顶部视图(默认白色背景)
    lazy var topView = UIView()

    /// 懒加载返回按钮(默认黑色箭头)
    lazy var backButton: UIButton = {
        let b = UIButton()
        b.contentEdgeInsets = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
        b.addTarget(self, action: #selector(backButtonDidSeleted), for: .touchUpInside)
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundColor()
    }

    /// Initialize topView and backButton
    func initSubview() {
        self.addTopView()
        self.addBackButton()
    }

    /// Initialize data
    func initData() { }
}

extension BaseViewController {
    /// - Parameter color: 设置视图控制器背景色，默认白色
    func backgroundColor(_ color: UIColor = .white) {
        view.backgroundColor = color
    }

    /// 添加自定义顶部视图
    /// - Parameters:
    ///   - safeHeight: 安全高度
    ///   - color: 背景色，默认白色
    func addTopView(_ safeHeight: Int = 44, _ color: UIColor = .white) {
        let autoY = kSafeMarginTop(safeHeight)
        view.addSubview(topView)
        topView.backgroundColor = color
        topView.snp.makeConstraints { make in
            make.height.equalTo(autoY)
            make.top.left.right.equalToSuperview()
        }
    }

    /// 添加自定义返回按钮
    /// - Parameters:
    ///   - safeHeight: 安全高度
    ///   - image: 默认黑色
    func addBackButton(_ safeHeight: Int = 44, _ image: UIImage? = UIImage(named: "vc_back_black")) {
        if topView.superview != nil {
            topView.addSubview(backButton)
        } else {
            view.addSubview(backButton)
        }

        backButton.setImage(image, for: .normal)
        let autoY = kSafeMarginTop(safeHeight) / 2
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(autoY)
            make.left.equalToSuperview()
        }
    }

    /// 自定义返回按钮事件
    @objc func backButtonDidSeleted() {
        if self.navigationController?.visibleViewController != nil {
            self.navigationController?.popViewController(animated: true)
        }
        self.dismiss(animated: true)
    }
}

struct AlertDialogData {
    var title: String?
    let message: String
    var positiveText: String?
    var positiveCallback: os_block_t?
    var neutralText: String?
    var neutralCallback: os_block_t?
    var negativeText: String?
    var negativeCallback: os_block_t?
}

enum DialogType {
    case yesNo
    case okCancel

    var leftLabel: String {
        switch self {
        case .okCancel: ""
        case .yesNo: ""
        }
    }

    var rightLabel: String {
        switch self {
        case .okCancel: ""
        case .yesNo: ""
        }
    }
}

protocol BaseProtocol: AnyObject {
    func alert(title: String?, message: String, buttonText: String, buttonCallback: os_block_t?)
    func alert(title: String?, message: String, dialogType: DialogType, okCallback: os_block_t?, cancelCallback: os_block_t?)
    func alert(data: AlertDialogData)
}

extension BaseProtocol {
    func alert(title: String? = nil, message: String, buttonText: String, buttonCallback: os_block_t? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let buttonAction = UIAlertAction(title: buttonText, style: .default) { _ in
            buttonCallback?()
        }
        alert.addAction(buttonAction)
        kTopViewController.present(alert, animated: true)
    }

    func alert(title: String? = nil, message: String, dialogType: DialogType, okCallback: os_block_t? = nil, cancelCallback: os_block_t? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: dialogType.leftLabel, style: .default) { _ in
            okCallback?()
        }
        let cancelAction = UIAlertAction(title: dialogType.rightLabel, style: .default) { _ in
            cancelCallback?()
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        kTopViewController.present(alert, animated: true)
    }

    func alert(data: AlertDialogData) {
        let alert = UIAlertController(title: data.title, message: data.message, preferredStyle: .alert)
        if let positiveText = data.positiveText {
            alert.addAction(UIAlertAction(title: positiveText, style: .default) { _ in
                _ = data.positiveCallback?()
            })
        }
        if let neutralText = data.neutralText {
            alert.addAction(UIAlertAction(title: neutralText, style: .default) { _ in
                _ = data.neutralCallback?()
            })
        }
        if let negativeText = data.negativeText {
            alert.addAction(UIAlertAction(title: negativeText, style: .default) { _ in
                _ = data.negativeCallback?()
            })
        }
        kTopViewController.present(alert, animated: true)
    }
}
