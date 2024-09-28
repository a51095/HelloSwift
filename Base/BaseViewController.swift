class BaseViewController: UIViewController, NetworkStatus, BaseProtocol {
    /// 懒加载顶部视图(默认白色背景)
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        return view
    }()

    /// 懒加载返回按钮(默认黑色箭头)
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "vc_back_black"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(backButtonDidSelect), for: .touchUpInside)
        return button
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
    func initData() {
        // 网络校验,有网则执行后续操作,网络不可用,则直接返回
        guard isReachable else { return }
    }
    
    func showTopViewAnimation() {
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
            self.topView.alpha = 0.5
        }, completion: { _ in
            UIView.animate(withDuration: 0.25) {
                self.topView.alpha = 1
                self.topView.transform = .identity
            }
        })
    }
    
    func hideTopViewAnimation() {
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
            self.topView.alpha = 0.5
        }, completion: { _ in
            UIView.animate(withDuration: 0.25) {
                self.topView.alpha = 0
                self.topView.transform = CGAffineTransform(translationX: 0, y: -80)
            }
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
}

extension BaseViewController {
    /// - Parameter color: 设置视图控制器背景色，默认白色
    func backgroundColor(_ color: UIColor = .white) {
        view.backgroundColor = color
    }

    /// 自定义顶部视图
    func addTopView() {
        view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: kSafeMarginTop).isActive = true
    }

    /// 自定义返回按钮
    func addBackButton() {
        topView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leftAnchor.constraint(equalTo: topView.leftAnchor).isActive = true
        backButton.bottomAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
    }

    /// 自定义返回按钮事件
    @objc func backButtonDidSelect() {
        if self.navigationController?.visibleViewController != nil {
            self.navigationController?.popViewController(animated: true)
        }
        self.dismiss(animated: true)
    }
}

extension BaseViewController {
    /// 添加前后台监听
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackgroundNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    /// BecomeActive
    @objc func didBecomeActiveNotification() { }
    
    /// EnterBackground
    @objc func didEnterBackgroundNotification() { }
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

    var leftText: String {
        switch self {
        case .okCancel: "Ok"
        case .yesNo: "Yes"
        }
    }

    var rightText: String {
        switch self {
        case .okCancel: "Cancel"
        case .yesNo: "No"
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
        let okAction = UIAlertAction(title: dialogType.leftText, style: .default) { _ in
            okCallback?()
        }
        let cancelAction = UIAlertAction(title: dialogType.rightText, style: .default) { _ in
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
