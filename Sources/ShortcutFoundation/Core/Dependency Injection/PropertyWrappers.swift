//
//  PropertyWrappers.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin on 2021-04-26.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import SwiftUI
#if !os(macOS)
import UIKit
#endif

@propertyWrapper public struct Inject<T> {
    private var injection: T
    public init() {
        self.injection = Injector.resolve(T.self)
    }
    public init(name: Injector.Name? = nil, container: Injector? = nil) {
        self.injection = container?.resolve(T.self, name: name) ?? Injector.resolve(T.self, name: name)
    }
    public var wrappedValue: T {
        get { return injection }
        mutating set { injection = newValue }
    }
    public var projectedValue: Inject<T> {
        get { return self }
        mutating set { self = newValue }
    }
}

@propertyWrapper public struct OptionalInject<T> {
    private var injection: T?
    public init() {
        self.injection = Injector.optional(T.self)
    }
    public init(name: Injector.Name? = nil, container: Injector? = nil) {
        self.injection = container?.optional(T.self, name: name) ?? Injector.optional(T.self, name: name)
    }
    public var wrappedValue: T? {
        get { return injection }
        mutating set { injection = newValue }
    }
    public var projectedValue: OptionalInject<T> {
        get { return self }
        mutating set { self = newValue }
    }
}

@propertyWrapper public struct LazyInject<T> {
    private var initialize = true
    private var injection: T!
    public var container: Injector?
    public var name: Injector.Name?
    public var args: Any?
    public init() {}
    public init(name: Injector.Name? = nil, container: Injector? = nil) {
        self.name = name
        self.container = container
    }
    public var isEmpty: Bool {
        return injection == nil
    }
    public var wrappedValue: T {
        mutating get {
            if initialize {
                self.initialize = false
                self.injection = container?.resolve(T.self, name: name, args: args) ?? Injector.resolve(T.self, name: name, args: args)
            }
            return injection
        }
        mutating set { injection = newValue  }
    }
    public var projectedValue: LazyInject<T> {
        get { return self }
        mutating set { self = newValue }
    }
    public mutating func release() {
        self.injection = nil
    }
}

@propertyWrapper public struct WeakLazyInject<T> {
    private var initialize = true
    private weak var injection: AnyObject?
    public var container: Injector?
    public var name: Injector.Name?
    public var args: Any?
    public init() {}
    public init(name: Injector.Name? = nil, container: Injector? = nil) {
        self.name = name
        self.container = container
    }
    public var isEmpty: Bool {
        return injection == nil
    }
    public var wrappedValue: T? {
        mutating get {
            if initialize {
                self.initialize = false
                let injection = container?.resolve(T.self, name: name, args: args) ?? Injector.resolve(T.self, name: name, args: args)
                self.injection = injection as AnyObject
                return injection
            }
            return injection as? T
        }
        mutating set { injection = newValue as AnyObject }
    }
    public var projectedValue: WeakLazyInject<T> {
        get { return self }
        mutating set { self = newValue }
    }
}

@propertyWrapper public struct InjectObject<T>: DynamicProperty where T: ObservableObject {
    @ObservedObject private var injection: T
    public init() {
        self.injection = Injector.resolve(T.self)
    }
    public init(name: Injector.Name? = nil, container: Injector? = nil) {
        self.injection = container?.resolve(T.self, name: name) ?? Injector.resolve(T.self, name: name)
    }
    public var wrappedValue: T {
        get { return injection }
        mutating set { injection = newValue }
    }
    public var projectedValue: ObservedObject<T>.Wrapper {
        return self.$injection
    }
}
