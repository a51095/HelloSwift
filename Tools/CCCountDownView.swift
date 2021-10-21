//
//  CCCountDownView.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/15.
//

/**
 * CCCountDownView:
 * 短信验证码视图
 * 使用方法,直接初始化CCCountDownView视图,添加到父视图上即可,支持后台持续计时;
 **/

/// 倒计时总时长,默认10秒
private let defaultTotal: Int = 10

final class CCCountDownView: UIView {
    /// 倒计时剩余时长(递减)
    private var countDownTotal = defaultTotal
    /// 倒计时label
    private let countDownLabel = UILabel()
    /// 当前系统绝对时间,进入后台后,仍持续计时
    private var startTime: Int = 0
    /// 定时器对象
    private var taskTimer = CCTimer()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 反初始化器
    deinit { print("CCCountDownView deinit~") }
    
    // MARK: - 初始化器
    init() {
        super.init(frame: .zero)
        self.setUI()
    }
    
    // MARK: - UI初始化
    private func setUI() {
        countDownLabel.text = "获取验证码"
        countDownLabel.textColor = .white
        countDownLabel.font = RegularFont(16)
        countDownLabel.textAlignment = .center
        addSubview(countDownLabel)
        countDownLabel.snp.makeConstraints { (make) in make.edges.equalToSuperview() }
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
                self.taskTimer.stop()
                self.countDownLabel.text = "重新获取"
                self.isUserInteractionEnabled = true
            }
        }
    }
        
    // MARK: - 获取剩余总时长
    private func remainingTime() -> Int {
        defaultTotal - (Int(CACurrentMediaTime()) - startTime)
    }
    
    // MARK: - 开始倒计时
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetData()
        taskTimer.start { self.updateData() }
    }
}
