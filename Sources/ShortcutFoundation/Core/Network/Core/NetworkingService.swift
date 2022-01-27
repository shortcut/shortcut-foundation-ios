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

public extension NetworkingClient {
    func get<Payload: Params>(_ route: String, params: Payload) -> AnyPublisher<Data, Error> {
        request(.get, route, params: params).publisher()
    }
    
    func get(_ route: String) -> AnyPublisher<Data, Error> {
        request(.get, route).publisher()
    }
    
    func get<Payload: Params>(_ route: String, params: Payload) -> AnyPublisher<Void, Error> {
        request(.get, route, params: params).voidPublisher()
    }
    
    func get(_ route: String) -> AnyPublisher<Void, Error> {
        request(.get, route).voidPublisher()
    }

    func post<Payload: Params>(_ route: String, params: Payload? = nil) -> AnyPublisher<Data, Error> {
        request(.post, route, params: params).publisher()
    }

    func put<Payload: Params>(_ route: String, params: Payload? = nil) -> AnyPublisher<Data, Error> {
        request(.put, route, params: params).publisher()
    }

    func patch<Payload: Params>(_ route: String, params: Payload? = nil) -> AnyPublisher<Data, Error> {
        request(.patch, route, params: params).publisher()
    }

    func delete<Payload: Params>(_ route: String, params: Payload? = nil) -> AnyPublisher<Data, Error> {
        request(.delete, route, params: params).publisher()
    }

//    func post<Payload: Params>(_ route: String, params: Payload? = nil) -> AnyPublisher<Void, Error> {
//        post(route, params: params)
//    }

    func put<Payload: Params>(_ route: String, params: Payload? = nil) -> AnyPublisher<Void, Error> {
        request(.put, route, params: params).voidPublisher()
    }

    func patch<Payload: Params>(_ route: String, params: Payload? = nil) -> AnyPublisher<Void, Error> {
        request(.patch, route, params: params).voidPublisher()
    }

    func delete<Payload: Params>(_ route: String, params: Payload? = nil) -> AnyPublisher<Void, Error> {
        request(.delete, route, params: params).voidPublisher()
    }

//    func get<Payload: Params>(_ route: String, params: Payload? = nil) -> AnyPublisher<Any, Error> {
//        network.get(route, params: params)
//    }
//
//    func post<Payload: Params>(_ route: String, params: Payload? = nil) -> AnyPublisher<Any, Error> {
//        network.post(route, params: params)
//    }
//
//    func put<Payload: Params>(_ route: String, params: Payload? = nil) -> AnyPublisher<Any, Error> {
//        network.put(route, params: params)
//    }
//
//    func patch<Payload: Params>(_ route: String, params: Payload? = nil) -> AnyPublisher<Any, Error> {
//        network.patch(route, params: params)
//    }
//
//    func delete<Payload: Params>(_ route: String, params: Payload? = nil) -> AnyPublisher<Any, Error> {
//        network.delete(route, params: params)
//    }
}
