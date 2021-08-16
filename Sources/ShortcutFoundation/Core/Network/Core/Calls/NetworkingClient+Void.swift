import Foundation
import Combine

public extension NetworkingClient {

    func get(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        get(route, params: params)
            .map { (_: Data) -> Void in () }
            .eraseToAnyPublisher()
    }

    func post(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        post(route, params: params)
            .map { (_: Data) -> Void in () }
        .eraseToAnyPublisher()
    }

    func put(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        put(route, params: params)
            .map { (_: Data) -> Void in () }
            .eraseToAnyPublisher()
    }

    func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        patch(route, params: params)
            .map { (_: Data) -> Void in () }
            .eraseToAnyPublisher()
    }

    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Void, Error> {
        delete(route, params: params)
            .map { (_: Data) -> Void in () }
            .eraseToAnyPublisher()
    }
}
