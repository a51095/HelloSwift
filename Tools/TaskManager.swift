//
//  TaskManager.swift
//  HelloSwift
//
//  Created by neusoft on 2024/3/1.
//

import Foundation

@available(iOS 13.0, *)
class TaskManager {
	private var task: Task<Void, Error>? = nil

	func startTask(_ block: @escaping () async -> Void) {
		task = Task {
			await block()
		}
	}

	func cancelTask() {
		task?.cancel()
	}
}
