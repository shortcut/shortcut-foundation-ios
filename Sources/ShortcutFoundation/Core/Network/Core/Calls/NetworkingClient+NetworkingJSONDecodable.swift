import Foundation
import Combine

public extension NetworkingClient {

    func get<T: Decodable>(_ route: String, params: Params = Params()) -> AnyPublisher<T, Error> {
        return get(route, params: params)
            .receive(on: DispatchQueue.main)
            .decode(type: T.self, decoder: self.decoder)
            .eraseToAnyPublisher()
    }

    func post<T: Decodable>(_ route: String,
                            params: Params = Params(),
                            keypath: String? = nil) -> AnyPublisher<T, Error> {
        return post(route, params: params)
            .receive(on: DispatchQueue.main)
            .decode(type: T.self, decoder: self.decoder)
            .eraseToAnyPublisher()
    }

    func put<T: Decodable>(_ route: String,
                           params: Params = Params(),
                           keypath: String? = nil) -> AnyPublisher<T, Error> {
        return put(route, params: params)
            .receive(on: DispatchQueue.main)
            .decode(type: T.self, decoder: self.decoder)
            .eraseToAnyPublisher()
    }

    func patch<T: Decodable>(_ route: String,
                             params: Params = Params(),
                             keypath: String? = nil) -> AnyPublisher<T, Error> {
        return patch(route, params: params)
            .receive(on: DispatchQueue.main)
            .decode(type: T.self, decoder: self.decoder)
            .eraseToAnyPublisher()
    }

    func delete<T: Decodable>(_ route: String,
                              params: Params = Params(),
                              keypath: String? = nil) -> AnyPublisher<T, Error> {
        return delete(route, params: params)
            .receive(on: DispatchQueue.main)
            .decode(type: T.self, decoder: self.decoder)
            .eraseToAnyPublisher()
    }
}
