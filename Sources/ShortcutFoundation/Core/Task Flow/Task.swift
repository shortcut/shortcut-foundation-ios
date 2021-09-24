//
//  Task.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin on 2021-09-13.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation

public protocol TaskFlow {
    func finish()
    func finish<T>(_ result: T)
    func finish(_ error: Error)
    func cancel()
}

public enum TaskState<LastResult> {
    case queued
    case running(LastResult?)
    case canceled
    case failed(Error)
    case finished(LastResult?)
}

public final class Task {
    public typealias Callback = (TaskFlow, Any?) -> Void
    fileprivate let callback: Callback
    fileprivate let runOnBackground: Bool
    
    public init(onBackground: Bool = false, closure: @escaping Callback) {
        runOnBackground = onBackground
        callback = closure
    }
    
    public func run(flow: TaskFlow, previousResult result: Any?) {
        guard runOnBackground else { callback(flow, result); return }
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
            self.callback(flow, result)
        }
    }
}
