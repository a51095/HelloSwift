//
//  CountDownManager.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/15.
//

/**
 * CountDownManage:
 * 剩余天数倒计时管理类
 * 支持后台倒计时
 * 共享数据源,可多处使用
 * 使用方法:
 * 添加CountDownManage代理对象,
 * 实现CountDownProtocol协议,
 * 在协议方法中,即可获取倒计时总时长(天,时,分,秒)
 **/

protocol CountDownProtocol: NSObjectProtocol {
    func refreshTime(result: [String])
}

final class CountDownManager {
    static var shared = CountDownManager()
    
    /// 倒计时总时长
    private var countDownTotal: Int = 0
    /// 当前系统绝对时间,进入后台后,仍持续计时
    private var startTime: Int = 0
    /// 代理对象
    weak var deletage: CountDownProtocol?
    /// 定时器对象
    private var taskTimer = Timer()
    
    // MARK: 停止
    func stop() { taskTimer.stop() }
    
    // MARK: 开始
    func run(start: Int, end: Int) {
        guard end - start > 0 else { return }
        
        countDownTotal = end - start
        startTime = Int(CACurrentMediaTime())
        
        taskTimer.start { self.deletage?.refreshTime(result: self.updateRemainingTime()) }
    }
    
    // MARK: 获取剩余总时长
    private func remainingTime() -> Int {
        countDownTotal - (Int(CACurrentMediaTime()) - startTime)
    }
    
    // MARK: 更新剩余总时长
    func updateRemainingTime() -> [String] {
        var resultString = "00:00:00:00"
        let remainingTotal = remainingTime()
        if remainingTotal > 0 {
            let day = remainingTotal / (24 * 60 * 60)
            let hours = remainingTotal / (60 * 60) - day * 24
            let minutes = remainingTotal / 60 - (day * 24 * 60) - (hours * 60)
            let seconds = remainingTotal % 60
            resultString = (String(format: "%02d:%02d:%02d:%02d", day, hours, minutes, seconds))
        } else {
            taskTimer.stop()
        }
        return resultString.components(separatedBy: ":")
    }
}
