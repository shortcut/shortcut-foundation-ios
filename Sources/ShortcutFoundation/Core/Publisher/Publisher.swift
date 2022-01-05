//
//  Publisher.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin on 2021-10-13.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation
import Combine

public final class Publisher<T>: NSObject, Combine {
    public var subscriptions = Set<AnyCancellable>()
    public private(set) var publisher: PassthroughSubject<T, PublisherError>?

    override init() {
        super.init()
        publisher = PassthroughSubject<T, PublisherError>()
    }

    deinit {
        subscriptions.removeAll()
    }
}

extension Publisher: Listener {
    public func listen(receiveCompletion: @escaping ((Subscribers.Completion<PublisherError>) -> Void),
                       receiveValue: @escaping ((T) -> Void)) {
        publisher?
            .sink(receiveCompletion: receiveCompletion, receiveValue: receiveValue)
            .store(in: &subscriptions)
    }

    public func listen(error on: @escaping ((Subscribers.Completion<PublisherError>) -> Void)) {
        publisher?
            .sink(receiveCompletion: on, receiveValue: { _ in })
            .store(in: &subscriptions)
    }

    public func listen(value on: @escaping ((T) -> Void)) {
        publisher?
            .sink(receiveCompletion: { _ in }, receiveValue: on)
            .store(in: &subscriptions)
    }
}

public protocol Sender: Template {
    func send(_ input: T)

    func send(error: PublisherError)
}

extension Publisher: Sender {
    public func send(_ input: T) {
        publisher?.send(input)
    }

    public func send(error: PublisherError) {
        publisher?.send(completion: .failure(error))
    }
}
