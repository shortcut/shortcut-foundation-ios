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

//    func getRequest<Payload: Params>(_ route: String, params: Payload) -> NetworkingRequest<Payload> {
//        request(.get, route, params: params)
//    }
//
//    func getRequest(_ route: String) -> NetworkingRequest<String> {
//        request(.get, route)
//    }
//
//    func postRequest<Payload: Params>(_ route: String, params: Payload) -> NetworkingRequest<Payload> {
//        request(.post, route, params: params)
//    }
//    func postRequest(_ route: String) -> NetworkingRequest<String> {
//        request(.post, route)
//    }
//
//    func putRequest<Payload: Params>(_ route: String, params: Payload) -> NetworkingRequest<Payload> {
//        request(.put, route, params: params)
//    }
//
//    func putRequest(_ route: String) -> NetworkingRequest<String> {
//        request(.put, route)
//    }
//
//    func patchRequest<Payload: Params>(_ route: String, params: Payload) -> NetworkingRequest<Payload> {
//        request(.patch, route, params: params)
//    }
//    func patchRequest(_ route: String) -> NetworkingRequest<String> {
//        request(.patch, route)
//    }
//
//    func deleteRequest<Payload: Params>(_ route: String, params: Payload) -> NetworkingRequest<Payload> {
//        request(.delete, route, params: params)
//    }
//    func deleteRequest(_ route: String) -> NetworkingRequest<String> {
//        request(.delete, route)
//    }
    
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
