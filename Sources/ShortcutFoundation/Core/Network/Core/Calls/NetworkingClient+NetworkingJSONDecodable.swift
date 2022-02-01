//
//  NetworkingClient+NetworkingJSONDecodable.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin, Karl Söderberg on 2021-08-16.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation
import Combine

public extension NetworkingClient {
    
    func get<ResponsePayload: Decodable, Payload: Params>(_ route: String, params: Payload?) -> AnyPublisher<ResponsePayload, Error> {
        return dataRequest(.get, route, params: params)
            .receive(on: DispatchQueue.main)
            .decode(type: ResponsePayload.self, decoder: self.decoder)
            .eraseToAnyPublisher()
    }
    
    func get<ResponsePayload: Decodable>(_ route: String) -> AnyPublisher<ResponsePayload, Error> {
        return dataRequest(.get, route)
            .receive(on: DispatchQueue.main)
            .decode(type: ResponsePayload.self, decoder: self.decoder)
            .eraseToAnyPublisher()
    }
    
    func post<ResponsePayload: Decodable, Payload: Params>(_ route: String,
                                                           params: Payload? = nil,
                                                           keypath: String? = nil) -> AnyPublisher<ResponsePayload, Error> {
        return dataRequest(.post, route, params: params)
            .receive(on: DispatchQueue.main)
            .decode(type: ResponsePayload.self, decoder: self.decoder)
            .eraseToAnyPublisher()
    }
    
    func post<ResponsePayload: Decodable>(_ route: String,
                                          keypath: String? = nil) -> AnyPublisher<ResponsePayload, Error> {
        return dataRequest(.post, route)
            .receive(on: DispatchQueue.main)
            .decode(type: ResponsePayload.self, decoder: self.decoder)
            .eraseToAnyPublisher()
    }
    
    func post(_ route: String, keypath: String? = nil) -> AnyPublisher<Void, Error> {
        return dataRequest(.post, route)
            .receive(on: DispatchQueue.main)
            .map { _ in Void() }
            .eraseToAnyPublisher()
    }
    
    func post<Payload: Params>(_ route: String, params: Payload? = nil) -> AnyPublisher<Void, Error> {
        return dataRequest(.post, route, params: params)
            .receive(on: DispatchQueue.main)
            .map { _ in Void() }
            .eraseToAnyPublisher()
    }
    
    func put<ResponsePayload: Decodable, Payload: Params>(_ route: String,
                                                          params: Payload? = nil,
                                                          keypath: String? = nil) -> AnyPublisher<ResponsePayload, Error> {
        return dataRequest(.put, route, params: params)
            .receive(on: DispatchQueue.main)
            .decode(type: ResponsePayload.self, decoder: self.decoder)
            .eraseToAnyPublisher()
    }
    
    func put<ResponsePayload: Decodable>(_ route: String,
                                         keypath: String? = nil) -> AnyPublisher<ResponsePayload, Error> {
        return dataRequest(.put, route)
            .receive(on: DispatchQueue.main)
            .decode(type: ResponsePayload.self, decoder: self.decoder)
            .eraseToAnyPublisher()
    }
    
    func patch<ResponsePayload: Decodable, Payload: Params>(_ route: String,
                                                            params: Payload? = nil,
                                                            keypath: String? = nil) -> AnyPublisher<ResponsePayload, Error> {
        return dataRequest(.patch, route, params: params)
            .receive(on: DispatchQueue.main)
            .decode(type: ResponsePayload.self, decoder: self.decoder)
            .eraseToAnyPublisher()
    }
    
    func patch<ResponsePayload: Decodable>(_ route: String,
                                           keypath: String? = nil) -> AnyPublisher<ResponsePayload, Error> {
        return dataRequest(.patch, route)
            .receive(on: DispatchQueue.main)
            .decode(type: ResponsePayload.self, decoder: self.decoder)
            .eraseToAnyPublisher()
    }
    
    func delete<ResponsePayload: Decodable, Payload: Params>(_ route: String,
                                                             params: Payload,
                                                             keypath: String? = nil) -> AnyPublisher<ResponsePayload, Error> {
        return dataRequest(.delete, route, params: params)
            .receive(on: DispatchQueue.main)
            .decode(type: ResponsePayload.self, decoder: self.decoder)
            .eraseToAnyPublisher()
    }
    
    func delete<ResponsePayload: Decodable>(_ route: String,
                                            keypath: String? = nil) -> AnyPublisher<ResponsePayload, Error> {
        return dataRequest(.delete, route)
            .receive(on: DispatchQueue.main)
            .decode(type: ResponsePayload.self, decoder: self.decoder)
            .eraseToAnyPublisher()
    }
    
    func delete<Payload: Params>(_ route: String, params: Payload) -> AnyPublisher<Void, Error> {
        request(.delete, route, params: params).voidPublisher()
    }
    
    func delete(_ route: String) -> AnyPublisher<Void, Error> {
        request(.delete, route).voidPublisher()
    }
    
    func dataRequest<Payload: Params>(_ httpVerb: HTTPVerb, _ route: String, params: Payload) -> AnyPublisher<Data, Error> {
        request(httpVerb, route, params: params).publisher()
    }
    
    func dataRequest(_ httpVerb: HTTPVerb, _ route: String) -> AnyPublisher<Data, Error> {
        request(httpVerb, route).publisher()
    }
    
    func postData(_ httpVerb: HTTPVerb, _ route: String) -> AnyPublisher<Data, Error> {
        request(.post, route).publisher()
    }
}
