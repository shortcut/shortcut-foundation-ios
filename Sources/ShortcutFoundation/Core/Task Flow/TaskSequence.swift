//
//  TaskSequence.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin on 2021-09-13.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation

public final class TaskSequence {
    fileprivate var tasks: [Task]
    
    public typealias FinishCallback = (TaskState<Any>?) -> Void
    public typealias ErrorCallback = (Error) -> Void
    public typealias CancelCallback = () -> Void
    
    fileprivate var finishCallback: FinishCallback = { _ in }
    fileprivate var errorCallback: ErrorCallback?
    fileprivate var cancelCallback: CancelCallback?
    
    fileprivate var currentState: TaskState<Any>? = .queued
    fileprivate let syncQueue = DispatchQueue(label: "io.shortcut.syncQueue",
                                              attributes: DispatchQueue.Attributes.concurrent)
    
    public var state: TaskState<Any>? {
        var val: TaskState<Any>?
        syncQueue.sync {
            val = self.currentState
        }
        return val
    }
    
    public init(tasks: [Task]) {
        self.tasks = tasks
    }
    
    public init(tasks: Task...) {
        self.tasks = tasks
    }
    
    public func whenDone(_ callback: @escaping FinishCallback) {
        guard case .queued = state else { assertionFailure("Cannot modify a task after starting") ; return }
        finishCallback = callback
    }
    
    public func onFinish(_ callback: @escaping FinishCallback) -> Self {
        guard case .queued = state else { assertionFailure("Cannot modify a task after starting") ; return self }
        finishCallback = callback
        return self
    }
    
    public func onError(_ callback: @escaping ErrorCallback) -> Self {
        guard case .queued = state else { assertionFailure("Cannot modify a task after starting") ; return self }
        errorCallback = callback
        return self
    }
    
    public func onCancel(_ callback: @escaping CancelCallback) -> Self {
        guard case .queued = state else { assertionFailure("Cannot modify a task after starting") ; return self }
        cancelCallback = callback
        return self
    }
    
    public func start() {
        guard case .queued = state else { assertionFailure("Cannot start a task twice") ; return }
        
        if !tasks.isEmpty {
            currentState = .running(Void.self)
            let task = tasks.first
            tasks.removeFirst()
            task?.run(flow: self, previousResult: nil)
        }
    }
    
    deinit {}
}

extension TaskSequence: TaskFlow {
    public func finish() {
        guard case .running = state else {
            return
        }
        
        guard !tasks.isEmpty else {
            syncQueue.sync(flags: .barrier) {
                self.currentState = .finished(nil)
            }
            DispatchQueue.main.async {
                self.finishCallback(self.state)
            }
            return
        }
        
        var task: Task?
        syncQueue.sync(flags: .barrier) {
            self.currentState = .running(nil)
            task = self.tasks.first
            self.tasks.removeFirst()
        }
        task?.run(flow: self, previousResult: nil)
    }
    
    public func finish<T>(_ result: T) {
        guard case .running = state else {
            return
        }
        
        guard !tasks.isEmpty else {
            syncQueue.sync(flags: .barrier) {
                self.currentState = .finished(result)
            }
            DispatchQueue.main.async {
                self.finishCallback(self.state)
            }
            return
        }
        
        var task: Task?
        syncQueue.sync(flags: .barrier) {
            self.currentState = .running(result)
            task = self.tasks.first
            self.tasks.removeFirst()
        }
        task?.run(flow: self, previousResult: result)
    }
    
    public func finish(_ error: Error) {
        syncQueue.sync(flags: .barrier) {
            self.tasks.removeAll()
            self.currentState = .failed(error)
        }
        
        DispatchQueue.main.async {
            guard let errorCallback = self.errorCallback else {
                self.finishCallback(self.state)
                return
            }
            errorCallback(error)
            self.errorCallback = nil
        }
    }
    
    public func cancel() {
        syncQueue.sync(flags: .barrier) {
            self.tasks.removeAll()
            self.currentState = .canceled
        }
        DispatchQueue.main.async {
            guard let cancelCallback = self.cancelCallback else {
                self.finishCallback(self.state)
                return
            }
            cancelCallback()
            self.cancelCallback = nil
        }
    }
}
