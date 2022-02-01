//
//  NetworkingClient+Requests.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin, Karl Söderberg on 2021-08-16.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation
import Combine

public extension NetworkingClient {
    
    internal func request<Payload: Params>(_ httpVerb: HTTPVerb, _ route: String, params: Payload) -> NetworkingRequest<Payload> {
        let req = NetworkingRequest<Payload>()
        req.baseURL = baseURL
        req.cachePolicy = cachePolicy
        req.headers = headers
        req.httpVerb = httpVerb
        req.route = route
        req.params = params
        req.parameterEncoding = parameterEncoding
        
        if let timeout = timeout {
            req.timeout = timeout
        }
        return req
    }
    
    internal func request(_ httpVerb: HTTPVerb, _ route: String) -> NetworkingRequest<String> {
        let req = NetworkingRequest<String>()
        req.baseURL = baseURL
        req.cachePolicy = cachePolicy
        req.headers = headers
        req.httpVerb = httpVerb
        req.route = route
        req.params = nil
        req.parameterEncoding = parameterEncoding
        
        if let timeout = timeout {
            req.timeout = timeout
        }
        return req
    }
}
