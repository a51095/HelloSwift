//
//  CountDownView.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/15.
//

/**
 * CountDownView:
 * 短信验证码视图
 * 使用方法,
 * 直接初始化CountDownView视图,
 * 添加到父视图上即可,支持后台持续计时;
 **/

struct ConfigOption {
    /// 倒计时总时长,默认10秒
    let total: CFTimeInterval
    let beginText: String
    let endText: String
    
    init(total: CFTimeInterval = 10.0, beginText: String = "开始倒计时", endText: String = "重新获取") {
        self.total = total
        self.beginText = beginText
        self.endText = endText
    }
}

final class CountDownView: UIView {
    /// 倒计时剩余时长(递减)
    private var countDownTotal: CFTimeInterval
    /// 倒计时label
    private var countDownLabel = UILabel()
    
    private let countDownOption: ConfigOption
    
    /// 当前系统绝对时间,进入后台后,仍持续计时
    private var startTime: CFTimeInterval = 0.0
    /// 定时器对象
    private var taskTimer = Timer()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 反初始化器
    deinit { kPrint("CountDownView deinit") }
    
    /// 初始化器
    init(option: ConfigOption = ConfigOption(), label: UILabel? = nil) {
        self.countDownOption = option
        self.countDownTotal = option.total
        super.init(frame: .zero)
        self.countDownLabel = configLabel(label)
    }
    
    func configLabel(_ label: UILabel?) -> UILabel {
        if let l = label {
            return l
        }
        
        let l = UILabel()
        l.text = countDownOption.beginText
        l.textColor = .white
        l.font = kRegularFont(16)
        l.textAlignment = .center
        addSubview(l)
        l.snp.makeConstraints { (make) in make.edges.equalToSuperview() }
        return l
    }
    
    /// 重置数据
    private func resetData() {
        countDownTotal = countDownOption.total
        isUserInteractionEnabled = false
        startTime = CACurrentMediaTime()
    }
    
    /// 更新UI
    private func updateData() {
        // 获取剩余总时长
        self.countDownTotal = self.remainingTime()
        // 主线程刷新UI
        DispatchQueue.main.async {
            if self.countDownTotal > 0 {
                self.countDownLabel.text = Int((self.countDownTotal)).str
            } else {
                self.taskTimer.stop()
                self.countDownLabel.text = self.countDownOption.endText
                self.isUserInteractionEnabled = true
            }
        }
    }
    
    /// 获取剩余总时长
    private func remainingTime() -> CFTimeInterval {
        countDownOption.total - (CACurrentMediaTime() - startTime)
    }
    
    /// 开始倒计时
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetData()
        taskTimer.start { self.updateData() }
    }
}
