//
//  NetworkingClient+JSON.swift
//  ShortcutFoundation
//
//  Created by Karl Söderberg on 2024-06-05.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation

public extension NetworkingClient {

    func get<ResponsePayload: Decodable, Payload: Encodable>(_ route: String, params: Payload) async throws -> ResponsePayload {
        let data = try await dataRequest(.get, route, params: params)
        do {
            return try self.decoder.decode(ResponsePayload.self, from: data)
        } catch {
            throw NetworkingError(error: error)
        }
    }

    func get<ResponsePayload: Decodable>(_ route: String) async throws -> ResponsePayload {
        let data = try await dataRequest(.get, route)
        do {
            return try self.decoder.decode(ResponsePayload.self, from: data)
        } catch {
            throw NetworkingError(error: error)
        }
    }

    func post<ResponsePayload: Decodable, Payload: Encodable>(_ route: String, params: Payload) async throws -> ResponsePayload {
        let data = try await dataRequest(.post, route, params: params)
        do {
            return try self.decoder.decode(ResponsePayload.self, from: data)
        } catch {
            throw NetworkingError(error: error)
        }
    }

    func post<ResponsePayload: Decodable>(_ route: String) async throws -> ResponsePayload {
        let data = try await dataRequest(.post, route)
        do {
            return try self.decoder.decode(ResponsePayload.self, from: data)
        } catch {
            throw NetworkingError(error: error)
        }
    }

    func post(_ route: String) async throws {
        _ = try await dataRequest(.post, route)
    }

    func post<Payload: Encodable>(_ route: String, params: Payload) async throws {
        _ = try await dataRequest(.post, route, params: params)
    }

    func put<ResponsePayload: Decodable, Payload: Encodable>(_ route: String, params: Payload) async throws -> ResponsePayload {
        let data = try await dataRequest(.put, route, params: params)
        do {
            return try self.decoder.decode(ResponsePayload.self, from: data)
        } catch {
            throw NetworkingError(error: error)
        }
    }

    func put<ResponsePayload: Decodable>(_ route: String) async throws -> ResponsePayload {
        let data = try await dataRequest(.put, route)
        do {
            return try self.decoder.decode(ResponsePayload.self, from: data)
        } catch {
            throw NetworkingError(error: error)
        }
    }

    func patch<ResponsePayload: Decodable, Payload: Encodable>(_ route: String, params: Payload) async throws -> ResponsePayload {
        let data = try await dataRequest(.patch, route, params: params)
        do {
            return try self.decoder.decode(ResponsePayload.self, from: data)
        } catch {
            throw NetworkingError(error: error)
        }
    }

    func patch<ResponsePayload: Decodable>(_ route: String) async throws -> ResponsePayload {
        let data = try await dataRequest(.patch, route)
        do {
            return try self.decoder.decode(ResponsePayload.self, from: data)
        } catch {
            throw NetworkingError(error: error)
        }
    }

    func delete<ResponsePayload: Decodable, Payload: Encodable>(_ route: String, params: Payload) async throws -> ResponsePayload {
        let data = try await dataRequest(.delete, route, params: params)
        do {
            return try self.decoder.decode(ResponsePayload.self, from: data)
        } catch {
            throw NetworkingError(error: error)
        }
    }

    func delete<ResponsePayload: Decodable>(_ route: String) async throws -> ResponsePayload {
        let data = try await dataRequest(.delete, route)
        do {
            return try self.decoder.decode(ResponsePayload.self, from: data)
        } catch {
            throw NetworkingError(error: error)
        }
    }

    func delete<Payload: Encodable>(_ route: String, params: Payload) async throws {
        _ = try await request(.delete, route, params: params).run()
    }

    func delete(_ route: String) async throws {
        _ = try await request(.delete, route).run()
    }

    func dataRequest<Payload: Encodable>(_ httpVerb: HTTPVerb, _ route: String, params: Payload) async throws -> Data {
        try await request(httpVerb, route, params: params).run()
    }

    func dataRequest(_ httpVerb: HTTPVerb, _ route: String) async throws -> Data {
        try await request(httpVerb, route).run()
    }

    func postData(_ httpVerb: HTTPVerb, _ route: String) async throws -> Data {
        try await request(.post, route).run()
    }
}
