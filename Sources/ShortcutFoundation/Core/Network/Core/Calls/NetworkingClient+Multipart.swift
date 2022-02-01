//
//  NetworkingClient+Multipart.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin, Karl Söderberg on 2021-08-16.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation
import Combine

public extension NetworkingClient {
    
    func upload<ResponsePayload: Decodable, Payload: Encodable>(_ route: String,
                              params: Payload,
                              multipartData: MultipartData) -> AnyPublisher<(ResponsePayload?,Progress), NetworkingError> {
        return post(route, params: params, multipartData: multipartData)
            .tryCompactMap { data, progress in
                if progress.isCancelled {
                    throw NetworkingError.init(status: .cancelled)
                }
                
                if let data = data {
                    return (try decoder.decode(ResponsePayload.self, from: data), progress)
                } else {
                    return (nil, progress)
                }
            }
            .mapError { NetworkingError(error: $0) }
            .eraseToAnyPublisher()
    }
    
    func upload<ResponsePayload: Decodable>(_ route: String, multipartData: MultipartData) -> AnyPublisher<(ResponsePayload?,Progress), NetworkingError> {
        return post(route, multipartData: [multipartData])
            .tryCompactMap { data, progress in
                if progress.isCancelled {
                    throw NetworkingError(status: .cancelled)
                }
                
                if let data = data, progress.isFinished {
                    return (try decoder.decode(ResponsePayload.self, from: data), progress)
                } else {
                    return (nil, progress)
                }
            }
            .mapError { NetworkingError(error: $0) }
            .eraseToAnyPublisher()
    }
    
    func post<Payload: Encodable>(_ route: String,
              params: Payload,
              multipartData: MultipartData) -> AnyPublisher<(Data?, Progress), NetworkingError> {
        return post(route, params: params, multipartData: [multipartData])
    }
    
    func put<Payload: Encodable>(_ route: String,
             params: Payload? = nil,
             multipartData: MultipartData) -> AnyPublisher<(Data?, Progress), NetworkingError> {
        return put(route, params: params, multipartData: [multipartData])
    }
    
    func patch<Payload: Encodable>(_ route: String,
               params: Payload? = nil,
               multipartData: MultipartData) -> AnyPublisher<(Data?, Progress), NetworkingError> {
        return patch(route, params: params, multipartData: [multipartData])
    }
    
    // Allow multiple multipart data
    func post<Payload: Encodable>(_ route: String,
              params: Payload,
              multipartData: [MultipartData]) -> AnyPublisher<(Data?, Progress), NetworkingError> {
        let req = request(.post, route, params: params)
        req.multipartData = multipartData
        return req.uploadPublisher()
    }
    
    // Allow multiple multipart data
    func post(_ route: String, multipartData: [MultipartData]) -> AnyPublisher<(Data?, Progress), NetworkingError> {
        let req = request(.post, route)
        req.multipartData = multipartData
        return req.uploadPublisher()
    }
    
    func put<Payload: Encodable>(_ route: String,
             params: Payload? = nil,
             multipartData: [MultipartData]) -> AnyPublisher<(Data?, Progress), NetworkingError> {
        let req = request(.put, route, params: params)
        req.multipartData = multipartData
        return req.uploadPublisher()
    }
    
    func patch<Payload: Encodable>(_ route: String,
               params: Payload? = nil,
               multipartData: [MultipartData]) -> AnyPublisher<(Data?, Progress), NetworkingError> {
        let req = request(.patch, route, params: params)
        req.multipartData = multipartData
                
        return req.uploadPublisher()
    }
    
}
