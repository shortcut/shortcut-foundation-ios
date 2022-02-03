//
//  InjectorRegistration.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin on 2021-04-26.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

public class InjectorRegistration<T>: InjectorOptions<T> {
    public var key: Int
    public var cacheKey: String

    public init(injector: Injector, key: Int, name: Injector.Name?) {
        self.key = key
        if let injectionName = name {
            self.cacheKey = String(key) + ":" + injectionName.rawValue
        } else {
            self.cacheKey = String(key)
        }
        super.init(injector: injector)
    }

    public func resolve(injector: Injector, args: Any?) -> T? {
        fatalError("abstract function")
    }

}

public final class InjectorRegistrationOnly<T>: InjectorRegistration<T> {
    public var factory: InjectorFactory<T>

    public init(injector: Injector, key: Int, name: Injector.Name?, factory: @escaping InjectorFactory<T>) {
        self.factory = factory
        super.init(injector: injector, key: key, name: name)
    }

    public final override func resolve(injector: Injector, args: Any?) -> T? {
        guard let injection = factory() else {
            return nil
        }
        mutate(injection, injector: injector, args: args)
        return injection
    }
}

public final class InjectorRegistrationMapping<T>: InjectorRegistration<T> {
    public var factory: InjectorFactoryMapping<T>

    public init(injector: Injector, key: Int, name: Injector.Name?, factory: @escaping InjectorFactoryMapping<T>) {
        self.factory = factory
        super.init(injector: injector, key: key, name: name)
    }

    public final override func resolve(injector: Injector, args: Any?) -> T? {
        guard let injection = factory(injector) else {
            return nil
        }
        mutate(injection, injector: injector, args: args)
        return injection
    }
}

public final class InjectorRegistrationArgumentsN<T>: InjectorRegistration<T> {
    public var factory: InjectorFactoryArgumentsN<T>

    public init(injector: Injector, key: Int, name: Injector.Name?, factory: @escaping InjectorFactoryArgumentsN<T>) {
        self.factory = factory
        super.init(injector: injector, key: key, name: name)
    }

    public final override func resolve(injector: Injector, args: Any?) -> T? {
        guard let injection = factory(injector, Injector.Args(args)) else {
            return nil
        }
        mutate(injection, injector: injector, args: args)
        return injection
    }
}
