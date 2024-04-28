//
//  ExampleAsyncViewController.swift
//  HelloSwift
//
//  Created by well on 2023/11/15.
//

import UIKit
import Foundation

class ExampleAsyncViewController: BaseViewController, ExampleProtocol {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSubview()
    }

    override func initSubview() {
        super.initSubview()

        let count = 3
        let limitH = 50
		let buttonTitleArray = ["方法 一", "方法 二", "方法 三"]

        var buttonArray = [UIButton]()
        for (idx) in 1...count {
            let button = UIButton()
            button.tag = idx + 100
            button.backgroundColor = .orange
            button.setTitle(buttonTitleArray[idx - 1], for: .normal)
            button.layer.cornerRadius = 8
            button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(didSeleted(button:)), for: .touchUpInside)
            button.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize(width: 200, height: limitH))
            }
            buttonArray.append(button)
        }

        let stackView = UIStackView(arrangedSubviews: buttonArray)
        stackView.axis = .vertical
        stackView.spacing = CGFloat(limitH)
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(view.snp_leftMargin).offset(20)
            make.right.equalTo(view.snp_rightMargin).offset(-20)
            make.height.equalTo(2 * count * limitH)
        }
    }

    @objc func didSeleted(button: UIButton) {
        switch button.tag {
        case 101:
            fetchDataWithCallback { result in
                kPrint("方法 一, 异步结果: ", result)
            }
        case 102:
            if #available(iOS 13.0, *) {
                Task {
                    let result = try await fetchDataWithAsync()
                    kPrint("方法 二, 异步结果: ", result)
                }
            } else {
                kPrint(UIDevice.current.systemVersion)
            }
        case 103:
            if #available(iOS 13.0, *) {
                Task {
                    let result = await fetchDataWithCheckedContinuation()
                    kPrint("方法 三, 异步结果: ", result)
                }
            } else {
                kPrint(UIDevice.current.systemVersion)
            }
        default: break
        }
    }

    private func fetchDataWithCallback(completion: @escaping (Swift.Result<Data, NetworkError>) -> Void) {
        view.showLoading()
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: URL(string: AppURL.adImageUrl)!) {
                completion(.success(data))
            } else {
                completion(.failure(.noData))
            }
            DispatchQueue.main.async {
                self.view.hideLoading()
            }
        }
    }

    @available(iOS 13.0.0, *)
    private func fetchDataWithAsync() async throws -> Swift.Result<Data, NetworkError> {
        view.showLoading()
        do {
            let url = URL(string: AppURL.adImageUrl)!
            let (data, _) = try await URLSession.shared.data(from: url)
            view.hideLoading()
            return .success(data)
        } catch {
            view.hideLoading()
            return .failure(.noData)
        }
    }

    @available(iOS 13.0.0, *)
    private func fetchDataWithCheckedContinuation() async -> Swift.Result<Data, NetworkError> {
        view.showLoading()
        return await withCheckedContinuation { continuation in
            Task(priority: .background) {
                do {
                    let url = URL(string: AppURL.adImageUrl)!
                    let (data, _) = try await URLSession.shared.data(from: url)
                    view.hideLoading()
                    return continuation.resume(returning: .success(data))
                } catch {
                    view.hideLoading()
                    continuation.resume(returning: .failure(.noData))
                }
            }
        }
    }
}
