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

    func getRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
        request(.get, route, params: params)
    }

    func postRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
        request(.post, route, params: params)
    }

    func putRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
        request(.put, route, params: params)
    }

    func patchRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
        request(.patch, route, params: params)
    }

    func deleteRequest(_ route: String, params: Params = Params()) -> NetworkingRequest {
        request(.delete, route, params: params)
    }

    internal func request(_ httpVerb: HTTPVerb, _ route: String, params: Params = Params()) -> NetworkingRequest {
        let req = NetworkingRequest()
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
}
