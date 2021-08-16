//
//  InjectorScope.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin on 2021-04-26.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

public protocol InjectorScopeType: AnyObject {
    func inject<T>(injector: Injector, registration: InjectorRegistration<T>, args: Any?) -> T?
}

public class InjectorScope: InjectorScopeType {
    public static let application = InjectorScopeCache()
    public static let cached = InjectorScopeCache()
    public static let graph = InjectorScopeGraph()
    public static let shared = InjectorScopeShare()
    public static let unique = InjectorScopeUnique()

    public func inject<T>(injector: Injector, registration: InjectorRegistration<T>, args: Any?) -> T? {
        fatalError("abstract")
    }
}

public class InjectorScopeCache: InjectorScope {
    public override init() {}

    public final override func inject<T>(injector: Injector, registration: InjectorRegistration<T>, args: Any?) -> T? {
        if let injection = cachedInjections[registration.cacheKey] as? T {
            return injection
        }
        let injection = registration.resolve(injector: injector, args: args)
        if let injection = injection {
            cachedInjections[registration.cacheKey] = injection
        }
        return injection
    }

    public final func reset() {
        cachedInjections.removeAll()
    }

    fileprivate var cachedInjections = [String: Any](minimumCapacity: 32)
}

public final class InjectorScopeGraph: InjectorScope {
    public override init() {}

    public final override func inject<T>(injector: Injector, registration: InjectorRegistration<T>, args: Any?) -> T? {
        if let injection = graph[registration.cacheKey] as? T {
            return injection
        }
        resolutionDepth += 1
        let injection = registration.resolve(injector: injector, args: args)
        resolutionDepth -= 1
        if resolutionDepth == 0 {
            graph.removeAll()
        } else if let injection = injection, type(of: injection as Any) is AnyClass {
            graph[registration.cacheKey] = injection
        }
        return injection
    }

    private var graph = [String: Any?](minimumCapacity: 32)
    private var resolutionDepth: Int = 0
}

public final class InjectorScopeShare: InjectorScope {
    public override init() {}

    public final override func inject<T>(injector: Injector, registration: InjectorRegistration<T>, args: Any?) -> T? {
        if let injection = cachedInjections[registration.cacheKey]?.injection as? T {
            return injection
        }
        let injection = registration.resolve(injector: injector, args: args)
        if let injection = injection, type(of: injection as Any) is AnyClass {
            cachedInjections[registration.cacheKey] = BoxWeak(injection: injection as AnyObject)
        }
        return injection
    }

    public final func reset() {
        cachedInjections.removeAll()
    }

    private struct BoxWeak {
        weak var injection: AnyObject?
    }

    private var cachedInjections = [String: BoxWeak](minimumCapacity: 32)
}

public final class InjectorScopeUnique: InjectorScope {
    public override init() {}
    public final override func inject<T>(injector: Injector, registration: InjectorRegistration<T>, args: Any?) -> T? {
        return registration.resolve(injector: injector, args: args)
    }
}
