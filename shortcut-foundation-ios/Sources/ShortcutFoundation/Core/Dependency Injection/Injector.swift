//
//  Injector.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin on 2021-04-26.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import SwiftUI
#if !os(macOS)
import UIKit
#endif

public protocol InjectorRegistering {
    static func registerAllInjections()
}

public protocol Injecting {
    var injector: Injector { get }
}

extension Injecting {
    public var injector: Injector {
        return Injector.root
    }
}

public final class Injector {
    public static var main = Injector()
    public static var root: Injector = main
    public static var defaultScope: InjectorScope = .application

    public init(parent: Injector? = nil) {
        self.parent = parent
    }

    public final func registerInjections() {
        lock.lock()
        defer { lock.unlock() }
        registrationCheck()
    }

    public static var registerInjections: (() -> Void)? = {
        lock.lock()
        defer { lock.unlock() }
        registrationCheck()
    }

    public static func reset() {
        lock.lock()
        defer { lock.unlock() }
        main = Injector()
        root = main
        InjectorScope.application.reset()
        InjectorScope.cached.reset()
        InjectorScope.shared.reset()
        registrationNeeded = true
    }

    public static func unmap<T>(_ type: T.Type = T.self) {
        main.unmap(type)
    }

    @discardableResult
    public static func map<T>(_ type: T.Type = T.self,
                              name: Injector.Name? = nil,
                              factory: @escaping InjectorFactory<T>) -> InjectorOptions<T> {
        return main.map(type, name: name, factory: factory)
    }

    @discardableResult
    public static func map<T>(_ type: T.Type = T.self,
                              name: Injector.Name? = nil,
                              factory: @escaping InjectorFactoryMapping<T>) -> InjectorOptions<T> {
        return main.map(type, name: name, factory: factory)
    }

    @discardableResult
    public static func map<T>(_ type: T.Type = T.self,
                              name: Injector.Name? = nil,
                              factory: @escaping InjectorFactoryArgumentsN<T>) -> InjectorOptions<T> {
        return main.map(type, name: name, factory: factory)
    }

    public final func unmap<T>(_ type: T.Type = T.self) {
        lock.lock()
        defer { lock.unlock() }
        let key = ObjectIdentifier(T.self).hashValue
        remove(key: key)
    }

    @discardableResult
    public final func map<T>(_ type: T.Type = T.self,
                             name: Injector.Name? = nil,
                             factory: @escaping InjectorFactory<T>) -> InjectorOptions<T> {
        lock.lock()
        defer { lock.unlock() }
        let key = ObjectIdentifier(T.self).hashValue
        let registration = InjectorRegistrationOnly(injector: self, key: key, name: name, factory: factory)
        add(registration: registration, with: key, name: name)
        return registration
    }

    @discardableResult
    public final func map<T>(_ type: T.Type = T.self,
                             name: Injector.Name? = nil,
                             factory: @escaping InjectorFactoryMapping<T>) -> InjectorOptions<T> {
        lock.lock()
        defer { lock.unlock() }
        let key = ObjectIdentifier(T.self).hashValue
        let registration = InjectorRegistrationMapping(injector: self, key: key, name: name, factory: factory)
        add(registration: registration, with: key, name: name)
        return registration
    }

    @discardableResult
    public final func map<T>(_ type: T.Type = T.self,
                             name: Injector.Name? = nil,
                             factory: @escaping InjectorFactoryArgumentsN<T>) -> InjectorOptions<T> {
        lock.lock()
        defer { lock.unlock() }
        let key = ObjectIdentifier(T.self).hashValue
        let registration = InjectorRegistrationArgumentsN(injector: self, key: key, name: name, factory: factory)
        add(registration: registration, with: key, name: name)
        return registration
    }

    public static func resolve<T>(_ type: T.Type = T.self, name: Injector.Name? = nil, args: Any? = nil) -> T {
        lock.lock()
        defer { lock.unlock() }
        registrationCheck()
        if let registration = root.lookup(type, name: name),
           let injection = registration.scope.inject(injector: root, registration: registration, args: args) {
            return injection
        }
        fatalError("injector: '\(T.self):\(name?.rawValue ?? "Anonymous")' not resolved. To disambiguate optionals use injector.optional().")
    }

    public final func resolve<T>(_ type: T.Type = T.self, name: Injector.Name? = nil, args: Any? = nil) -> T {
        lock.lock()
        defer { lock.unlock() }
        registrationCheck()
        if let registration = lookup(type, name: name),
           let injection = registration.scope.inject(injector: self, registration: registration, args: args) {
            return injection
        }
        fatalError("injector: '\(T.self):\(name?.rawValue ?? "Anonymous")' not resolved. To disambiguate optionals use injector.optional().")
    }

    public static func optional<T>(_ type: T.Type = T.self, name: Injector.Name? = nil, args: Any? = nil) -> T? {
        lock.lock()
        defer { lock.unlock() }
        registrationCheck()
        if let registration = root.lookup(type, name: name),
           let injection = registration.scope.inject(injector: root, registration: registration, args: args) {
            return injection
        }
        return nil
    }

    public final func optional<T>(_ type: T.Type = T.self, name: Injector.Name? = nil, args: Any? = nil) -> T? {
        lock.lock()
        defer { lock.unlock() }
        registrationCheck()
        if let registration = lookup(type, name: name),
           let injection = registration.scope.inject(injector: self, registration: registration, args: args) {
            return injection
        }
        return nil
    }

    private final func lookup<T>(_ type: T.Type, name: Injector.Name?) -> InjectorRegistration<T>? {
        let key = ObjectIdentifier(T.self).hashValue
        let containerName = name?.rawValue ?? anonymous
        if let container = registrations[key], let registration = container[containerName] {
            return registration as? InjectorRegistration<T>
        }
        if let parent = parent, let registration = parent.lookup(type, name: name) {
            return registration
        }
        return nil
    }

    private final func add<T>(registration: InjectorRegistration<T>, with key: Int, name: Injector.Name?) {
        if var container = registrations[key] {
            container[name?.rawValue ?? anonymous] = registration
            registrations[key] = container
        } else {
            registrations[key] = [name?.rawValue ?? anonymous: registration]
        }
    }

    private final func remove(key: Int) {
        if registrations.has(key) {
            registrations[key] = nil
        }
    }

    private let anonymous = "*"
    private let parent: Injector?
    private let lock = Injector.lock
    private var registrations = [Int: [String: Any]]()
}

private class InjectorRecursiveLock {
    init() {
        pthread_mutexattr_init(&recursiveMutexAttr)
        pthread_mutexattr_settype(&recursiveMutexAttr, PTHREAD_MUTEX_RECURSIVE)
        pthread_mutex_init(&recursiveMutex, &recursiveMutexAttr)
    }
    @inline(__always)
    func lock() {
        pthread_mutex_lock(&recursiveMutex)
    }
    @inline(__always)
    func unlock() {
        pthread_mutex_unlock(&recursiveMutex)
    }
    private var recursiveMutex = pthread_mutex_t()
    private var recursiveMutexAttr = pthread_mutexattr_t()
}

extension Injector {
    private static let lock = InjectorRecursiveLock()
}

private var registrationNeeded = true

@inline(__always)
private func registrationCheck() {
    guard registrationNeeded else {
        return
    }
    if let registering = (Injector.root as Any) as? InjectorRegistering {
        type(of: registering).registerAllInjections()
    }
    registrationNeeded = false
}
