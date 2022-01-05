//
//  NetworkingService.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin, Karl Söderberg on 2021-08-16.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation
import Combine

public protocol NetworkingService {
    var network: NetworkingClient { get }
}

public extension NetworkingService {
    func get(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        network.get(route, params: params)
    }

    func post(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        network.post(route, params: params)
    }

    func put(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        network.put(route, params: params)
    }

    func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        network.patch(route, params: params)
    }

    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        network.delete(route, params: params)
    }

    func get(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        network.get(route, params: params)
    }

    func post(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        network.post(route, params: params)
    }

    func put(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        network.put(route, params: params)
    }

    func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        network.patch(route, params: params)
    }

    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        network.delete(route, params: params)
    }

    func get(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        network.get(route, params: params)
    }

    func post(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        network.post(route, params: params)
    }

    func put(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        network.put(route, params: params)
    }

    func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        network.patch(route, params: params)
    }

    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Any, Error> {
        network.delete(route, params: params)
    }
}
