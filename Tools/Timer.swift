final class Timer {
    /// 定时器对象
    private var taskTimer: DispatchSourceTimer?
    
    // MARK: 反初始化器
    deinit { print("Timer deinit") }
    
    /**
     启动定时器
     
     - parameter taskQueue:    task queue(Default: .main)
     - parameter interval:     the repeat interval for the timer in seconds (Default: .seconds(1))
     - parameter leeway:       the leeway for the timer (Default: .nanoseconds(0))
     - parameter eventHandler: set the event handler work item for the dispatch source.
     */
    
    // MARK: 启动定时器
    func start(taskQueue: DispatchQueue = .main, interval: DispatchTimeInterval = .seconds(1), leeway: DispatchTimeInterval = .nanoseconds(0), eventHandler: @escaping os_block_t) {
        // 非空校验,若taskTimer对象已存在,则直接返回
        guard taskTimer == nil else { return }
        
        taskTimer = DispatchSource.makeTimerSource(flags: [], queue: taskQueue)
        taskTimer?.schedule(deadline: .now(), repeating: interval, leeway: leeway)
        taskTimer?.setEventHandler { eventHandler() }
        taskTimer?.resume()
    }
    
    // MARK: 停止并释放定时器
    func stop() { taskTimer?.cancel(); taskTimer = nil }
}
