////
////  NetworkingClient+Void.swift
////  ShortcutFoundation
////
////  Created by Gabriel Sabadin, Karl Söderberg on 2021-08-16.
////  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
////
//
//import Foundation
//import Combine
//
//public extension NetworkingClient {
//    
//    func get<Payload: Params>(_ route: String, params: Payload) -> AnyPublisher<Void, Error> {
//        get(route, params: params)
//            .map { (_: Data) -> Void in () }
//            .eraseToAnyPublisher()
//    }
//    
//    func get(_ route: String) -> AnyPublisher<Void, Error> {
//        get(route)
//            .map { (_: Data) -> Void in () }
//            .eraseToAnyPublisher()
//    }
//    
//    func post<Payload: Params>(_ route: String, params: Payload) -> AnyPublisher<Void, Error> {
//         post(route, params: params)
//            .map { _ in Void() }
//            .eraseToAnyPublisher()
//    }
//    
//    func post(_ route: String) -> AnyPublisher<Void, Error> {
//        post(route)
//            .map { (_: Data) -> Void in () }
//            .eraseToAnyPublisher()
//    }
//    
//    func put<Payload: Params>(_ route: String, params: Payload) -> AnyPublisher<Void, Error> {
//        put(route, params: params)
//            .map { (_: Data) -> Void in () }
//            .eraseToAnyPublisher()
//    }
//    
//    func put(_ route: String) -> AnyPublisher<Void, Error> {
//        put(route)
//            .map { (_: Data) -> Void in () }
//            .eraseToAnyPublisher()
//    }
//    
//    func patch<Payload: Params>(_ route: String, params: Payload) -> AnyPublisher<Void, Error> {
//        patch(route, params: params)
//            .map { (_: Data) -> Void in () }
//            .eraseToAnyPublisher()
//    }
//    
//    func patch(_ route: String) -> AnyPublisher<Void, Error> {
//        patch(route)
//            .map { (_: Data) -> Void in () }
//            .eraseToAnyPublisher()
//    }
//    
//    func delete<Payload: Params>(_ route: String, params: Payload) -> AnyPublisher<Void, Error> {
//        delete(route, params: params)
//            .map { (_: Data) -> Void in () }
//            .eraseToAnyPublisher()
//    }
//    
//    func delete(_ route: String) -> AnyPublisher<Void, Error> {
//        delete(route)
//            .map { (_: Data) -> Void in () }
//            .eraseToAnyPublisher()
//    }
//}
