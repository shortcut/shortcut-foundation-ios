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
    
    func upload<ResponsePayload: Decodable, Payload: Params>(_ route: String,
                              params: Payload? = nil,
                              multipartData: MultipartData) -> AnyPublisher<(ResponsePayload?,Progress), Error> {
        return post(route, params: params, multipartData: multipartData)
            .receive(on: DispatchQueue.main)
            .tryCompactMap { data, progress in
                if progress.isCancelled {
                    throw NetworkingError.init(status: .cancelled)
                }
                
                if let data = data, progress.isFinished {
                    return (try decoder.decode(ResponsePayload.self, from: data), progress)
                } else {
                    return (nil, progress)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func post<Payload: Params>(_ route: String,
              params: Payload? = nil,
              multipartData: MultipartData) -> AnyPublisher<(Data?, Progress), Error> {
        return post(route, params: params, multipartData: [multipartData])
    }
    
    func put<Payload: Params>(_ route: String,
             params: Payload? = nil,
             multipartData: MultipartData) -> AnyPublisher<(Data?, Progress), Error> {
        return put(route, params: params, multipartData: [multipartData])
    }
    
    func patch<Payload: Params>(_ route: String,
               params: Payload? = nil,
               multipartData: MultipartData) -> AnyPublisher<(Data?, Progress), Error> {
        return patch(route, params: params, multipartData: [multipartData])
    }
    
    // Allow multiple multipart data
    func post<Payload: Params>(_ route: String,
              params: Payload? = nil,
              multipartData: [MultipartData]) -> AnyPublisher<(Data?, Progress), Error> {
        let req = request(.post, route, params: params)
        req.multipartData = multipartData
        return req.uploadPublisher()
    }
    
    func put<Payload: Params>(_ route: String,
             params: Payload? = nil,
             multipartData: [MultipartData]) -> AnyPublisher<(Data?, Progress), Error> {
        let req = request(.put, route, params: params)
        req.multipartData = multipartData
        return req.uploadPublisher()
    }
    
    func patch<Payload: Params>(_ route: String,
               params: Payload? = nil,
               multipartData: [MultipartData]) -> AnyPublisher<(Data?, Progress), Error> {
        let req = request(.patch, route, params: params)
        req.multipartData = multipartData
                
        return req.uploadPublisher()
    }
    
}
