// MARK: 当定时器所在类销毁,定时器一并销毁时,使用Timer对象方法
final class Timer {
    /// 定时器对象
    private var taskTimer: DispatchSourceTimer?

    // MARK: 反初始化器
    deinit { kPrint("Timer deinit") }

    /// 启动定时器
    /// - Parameters:
    ///   - taskQueue: task queue(Default: .main)
    ///   - interval: the repeat interval for the timer in seconds (Default: .seconds(1))
    ///     If a single task needs to be executed, use '.never'
    ///   - leeway: the leeway for the timer (Default: .nanoseconds(0))
    ///   - eventHandler: set the event handler work item for the dispatch source
    func start(taskQueue: DispatchQueue = .main, interval: DispatchTimeInterval = .seconds(1), leeway: DispatchTimeInterval = .nanoseconds(0), eventHandler: @escaping os_block_t) {
        // 非空校验,若taskTimer对象已存在,则直接返回
        guard taskTimer == nil else { return }

        taskTimer = DispatchSource.makeTimerSource(flags: [], queue: taskQueue)
        taskTimer?.schedule(deadline: .now(), repeating: interval, leeway: leeway)
        taskTimer?.setEventHandler { eventHandler() }
        taskTimer?.activate()
    }

    /// 停止并释放定时器
    func stop() { taskTimer?.cancel(); taskTimer = nil }
}

// MARK: 当定时器所在类销毁,但需要保留定时器时,使用Timer静态方法
extension Timer {
    static let shared: Timer = {
        let instance = Timer()
        return instance
    }()

    /// 启动定时器
    static func start(taskQueue: DispatchQueue = .main, interval: DispatchTimeInterval = .seconds(1), leeway: DispatchTimeInterval = .nanoseconds(0), eventHandler: @escaping os_block_t) {
        shared.start(taskQueue: taskQueue, interval: interval, leeway: leeway, eventHandler: eventHandler)
    }
    /// 停止定时器
    static func stop() { shared.stop() }
}
