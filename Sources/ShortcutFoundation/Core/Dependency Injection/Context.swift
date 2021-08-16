//
//  Context.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin on 2021-04-26.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation

public protocol IContext {
    var injector: Injector { get }

    func configure(_ config: Config, completion: () -> Void)
    func configure(_ configs: [Config], completion: () -> Void)
}

public struct Context: IContext {
    private let _injector: Injector = Injector.main

    public var injector: Injector {
        return _injector
    }

    public init() { }

    public init(_ config: Config) {
        self.init()
        configure(config) {}
    }

    public func configure(_ config: Config, completion: () -> Void) {
        configure([config], completion: completion)
    }

    public func configure(_ configs: [Config], completion: () -> Void) {
        for config in configs {
            config.configure(injector)
        }

        completion()
    }
}
