//
//  CCCountDownView.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/14.
//

import UIKit

/// 倒计时总时长,默认10秒
private let defaultTotal: Int = 10
// eg: 使用方法,直接初始化CCCountDownView视图,添加到父视图上即可,支持后台持续计时;
class CCCountDownView: UIView {
    
    /// 倒计时总时长
    private var countDownTotal = defaultTotal
    
    /// 倒计时label
    private let countDownLabel = UILabel()
    
    /// 当前系统绝对时间,进入后台后,仍持续计时
    private var startTime: Int = 0
    
    /// 定时器对象
    private var taskTimer: DispatchSourceTimer?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 反初始化器
    deinit {
        print("CCCountDownView deinit~")
    }
    
    // MARK: - 初始化器
    init() {
        super.init(frame: .zero)
        self.setUI()
    }
    
    // MARK: - UI初始化
    private func setUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(countDownDidSeleted))
        addGestureRecognizer(tap)
        countDownLabel.text = "获取验证码"
        countDownLabel.textColor = .white
        countDownLabel.font = RegularFont(16)
        countDownLabel.textAlignment = .center
        addSubview(countDownLabel)
        countDownLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - 重置数据
    private func resetData() {
        countDownTotal = defaultTotal
        isUserInteractionEnabled = false
        startTime = Int(CACurrentMediaTime())
    }
    
    // MARK: - 更新UI
    private func updateData() {
        // 获取剩余总时长
        self.countDownTotal = self.remainingTime()
        // 主线程刷新UI
        DispatchQueue.main.async {
            if self.countDownTotal > 0 {
                self.countDownLabel.text = self.countDownTotal.str
            }else {
                self.taskTimer?.cancel()
                self.countDownLabel.text = "重新获取"
                self.isUserInteractionEnabled = true
            }
        }
    }
    
    // MARK: - 开始倒计时
    @objc private func countDownDidSeleted() {
        resetData()
        taskTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue(label: "count_down_queue"))
        taskTimer?.schedule(deadline: .now(), repeating: .seconds(1), leeway: .seconds(0))
        taskTimer?.setEventHandler { self.updateData() }
        taskTimer?.resume()
    }
    
    // MARK: - 获取剩余总时长
    private func remainingTime() -> Int {
        return defaultTotal - (Int(CACurrentMediaTime()) - startTime)
    }
}
