//
//  NetworkingClient+Data.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin, Karl Söderberg on 2021-08-16.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation
import Combine

public extension NetworkingClient {

    func get(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        request(.get, route, params: params).publisher()
    }

    func post(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        request(.post, route, params: params).publisher()
    }

    func put(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        request(.put, route, params: params).publisher()
    }

    func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        request(.patch, route, params: params).publisher()
    }

    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        request(.delete, route, params: params).publisher()
    }
}
