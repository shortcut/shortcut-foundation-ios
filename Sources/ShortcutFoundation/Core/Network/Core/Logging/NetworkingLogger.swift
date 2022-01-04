import Foundation

final class NetworkingLogger {
    @LazyInject private var logger: Loggable

    func log(request: URLRequest) {
        if let verb = request.httpMethod,
            let url = request.url {
            logger.log(message: "\(verb) '\(url.absoluteString)'")
            logHeaders(request)
            logBody(request)
        }
    }

    func log(response: URLResponse, data: Data) {
        if let response = response as? HTTPURLResponse {
            logStatusCodeAndURL(response)
        }

        logger.log(message: String(decoding: data, as: UTF8.self))
    }

    private func logHeaders(_ urlRequest: URLRequest) {
        if let allHTTPHeaderFields = urlRequest.allHTTPHeaderFields {
            for (key, value) in allHTTPHeaderFields {
                logger.log(message: "  \(key) : \(value)")
            }
        }
    }

    private func logBody(_ urlRequest: URLRequest) {
        if let body = urlRequest.httpBody,
            let str = String(data: body, encoding: .utf8) {
            logger.log(message: "  HttpBody : \(str)")
        }
    }

    private func logStatusCodeAndURL(_ urlResponse: HTTPURLResponse) {
        if let url = urlResponse.url {
            logger.log(message: "\(urlResponse.statusCode) '\(url.absoluteString)'")
        }
    }
}
