//
//  InjectorOptions.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin on 2021-04-26.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

// swiftlint:disable identifier_name

public typealias InjectorFactory<T> = () -> T?
public typealias InjectorFactoryMapping<T> = (_ injector: Injector) -> T?
public typealias InjectorFactoryArgumentsN<T> = (_ injector: Injector, _ args: Injector.Args) -> T?
public typealias InjectorFactoryMutator<T> = (_ injector: Injector, _ injection: T) -> Void
public typealias InjectorFactoryMutatorArgumentsN<T> = (_ injector: Injector, _ injection: T, _ args: Injector.Args) -> Void

public class InjectorOptions<T> {
    public var scope: InjectorScope

    fileprivate var mutator: InjectorFactoryMutator<T>?
    fileprivate var mutatorWithArgumentsN: InjectorFactoryMutatorArgumentsN<T>?
    fileprivate weak var injector: Injector?

    public init(injector: Injector) {
        self.injector = injector
        self.scope = Injector.defaultScope
    }

    @discardableResult
    public final func implements<Protocol>(_ type: Protocol.Type, name: Injector.Name? = nil) -> InjectorOptions<T> {
        injector?.map(type.self, name: name) { r, _ in r.resolve(T.self) as? Protocol }
        return self
    }

    @discardableResult
    public final func resolveProperties(_ block: @escaping InjectorFactoryMutator<T>) -> InjectorOptions<T> {
        mutator = block
        return self
    }

    @discardableResult
    public final func resolveProperties(_ block: @escaping InjectorFactoryMutatorArgumentsN<T>) -> InjectorOptions<T> {
        mutatorWithArgumentsN = block
        return self
    }

    @discardableResult
    public final func scope(_ scope: InjectorScope) -> InjectorOptions<T> {
        self.scope = scope
        return self
    }

    func mutate(_ injection: T, injector: Injector, args: Any?) {
        self.mutator?(injector, injection)
        if let mutatorWithArgumentsN = mutatorWithArgumentsN {
            mutatorWithArgumentsN(injector, injection, Injector.Args(args))
        }
    }
}
