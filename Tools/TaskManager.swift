//
//  TaskManager.swift
//  HelloSwift
//
//  Created by neusoft on 2024/3/1.
//

import Foundation

@available(iOS 13.0, *)
class TaskManager {
    /// 任务组
    private var tasks: [String: Task<Void, Never>] = [:]
    /// 线程安全
    private let lock = NSLock()
    
    /// 启动一个任务
    func startTask(
        id: String,
        priority: TaskPriority = .medium,
        operation: @escaping () async throws -> Void
    ) {
        cancelTask(id: id)  // 先取消同名任务
        
        let task = Task(priority: priority) {
            do {
                try await operation()
                print("✅ 任务 \(id) 完成")
            } catch is CancellationError {
                print("⏹️ 任务 \(id) 被取消")
            } catch {
                print("❌ 任务 \(id) 失败: \(error)")
            }
            
            // 任务完成后清理
            removeTask(id: id)
        }
        
        lock.lock()
        tasks[id] = task
        lock.unlock()
    }
    
    /// 取消特定任务
    func cancelTask(id: String) {
        lock.lock()
        defer { lock.unlock() }
        
        tasks[id]?.cancel()
        tasks.removeValue(forKey: id)
    }
    
    /// 取消所有任务
    func cancelAll() {
        lock.lock()
        let allTasks = tasks
        tasks.removeAll()
        lock.unlock()
        
        for (id, task) in allTasks {
            print("正在取消任务: \(id)")
            task.cancel()
        }
    }
    
    /// 检查任务是否在运行
    func isTaskRunning(id: String) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        return tasks[id] != nil && !(tasks[id]?.isCancelled ?? true)
    }
    
    /// 获取所有运行中的任务ID
    var runningTaskIDs: [String] {
        lock.lock()
        defer { lock.unlock() }
        return tasks.keys.filter { !(tasks[$0]?.isCancelled ?? true) }.map { $0 }
    }
    
    /// 清理任务
    private func removeTask(id: String) {
        lock.lock()
        tasks.removeValue(forKey: id)
        lock.unlock()
    }
    
    deinit {
        cancelAll()
    }
}
