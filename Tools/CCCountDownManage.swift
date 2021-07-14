//
//  CCCountDownManage.swift
//  HelloSwift
//
//  Created by a51095 on 2021/7/14.
//

import UIKit
import Foundation

protocol CCCountDownManageProtocol: NSObjectProtocol {
    func refreshTime(result: [String])
}

// eg: 添加CCCountDownManage代理对象,并实现CCCountDownManageProtocol协议,协议方法中,即可获取倒计时总时长(天,时,分,秒)
class CCCountDownManage {
    static var shared = CCCountDownManage()
    
    /// 倒计时总时长
    private var countDownTotal: Int = 0
    
    /// 当前系统绝对时间,进入后台后,仍持续计时
    private var startTime: Int = 0
    ///
    public weak var deletage: CCCountDownManageProtocol?
    
    /// 定时器对象
    private lazy var taskTimer: DispatchSourceTimer? = {
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue(label: "count_down_manage_queue"))
        return timer
    }()
    
    // MARK: - 开始活动倒计时
    public func run(start: Int, end: Int) {
        guard end - start > 0 else { return }
        
        countDownTotal = end - start
        startTime = Int(CACurrentMediaTime())
        
        taskTimer?.schedule(deadline: .now(), repeating: .seconds(1), leeway: .seconds(0))
        taskTimer?.setEventHandler {
            self.deletage?.refreshTime(result: self.updateRemainingTime())
        }
        taskTimer?.resume()
    }
    
    // MARK: - 获取剩余总时长
    private func remainingTime() -> Int {
        countDownTotal - (Int(CACurrentMediaTime()) - startTime)
    }
    
    public func updateRemainingTime() -> [String] {
        var resultString = "00:00:00:00"
        let remainingTotal = remainingTime()
        if remainingTotal > 0 {
            let day = remainingTotal / (24 * 60 * 60)
            let hours = remainingTotal / (60 * 60) - day * 24
            let minutes = remainingTotal / 60 - (day * 24 * 60) - (hours * 60)
            let seconds = remainingTotal % 60
            resultString = (String(format: "%02d:%02d:%02d:%02d",day, hours, minutes, seconds))
        }else {
            taskTimer?.cancel()
        }
        return resultString.components(separatedBy: ":")
    }
    
    // MARK: - 手动停止定时器,并释放定时器对象
    public func cannel() {
        taskTimer?.cancel()
        taskTimer = nil
    }
}
