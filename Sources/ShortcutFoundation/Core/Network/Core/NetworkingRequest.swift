//
//  NetworkingRequest.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin, Karl Söderberg on 2021-08-16.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation
import Combine


public class NetworkingRequest<Payload: Encodable> {

    var parameterEncoding = ParameterEncoding.urlEncoded
    var baseURL = ""
    var route = ""
    var httpVerb = HTTPVerb.get
    var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    var encoder = JSONEncoder()

    var params: Payload?
    var headers = [String: String]()

    var multipartData: [MultipartData]?
    private let logger = NetworkingLogger()
    var timeout: TimeInterval?
    var progressPublisher = CurrentValueSubject<Progress, NetworkingError>(Progress())
    var authenticationChallengeHandler: AuthenticationChallengeHandler?

    public func publisher() -> AnyPublisher<Data, NetworkingError> {

        guard let urlRequest = buildURLRequest() else {
            return Fail(error: NetworkingError.unableToParseRequest)
                .eraseToAnyPublisher()
        }

        logger.log(request: urlRequest)

        let config = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: config,
                                    delegate: SessionDelegate(publisher: progressPublisher, authenticationChallengeHandler: authenticationChallengeHandler),
                                    delegateQueue: nil)

        return urlSession.dataTaskPublisher(for: urlRequest)
            .tryMap { try self.handleResponse(data: $0.data, response: $0.response) }
            .mapError { NetworkingError(error: $0) }
            .eraseToAnyPublisher()
    }

    private func handleResponse(data: Data, response: URLResponse) throws -> Data {
        self.logger.log(response: response, data: data)

        if let httpURLResponse = response as? HTTPURLResponse {
            if !(200...299 ~= httpURLResponse.statusCode) {
                var error = NetworkingError(errorCode: httpURLResponse.statusCode)
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    error.jsonPayload = json
                }
                throw error
            }
        }
        return data
    }

    public func voidPublisher() -> NetworkPublisher<Void> {
        publisher().map { _ in Void() }.eraseToAnyPublisher()
    }

    public func uploadPublisher() -> NetworkPublisher<(Data?, Progress)> {
        publisher()
            .combineLatest(progressPublisher)
            .map { ($0.0, $0.1) }
            .eraseToAnyPublisher()
    }

    private func getURLWithParams() -> String {
        let urlString = baseURL + route
        guard let url = URL(string: urlString) else {
            return urlString
        }

        guard let params = params else {
            return urlString
        }

        let mirror = Mirror(reflecting: params)

        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            var queryItems = urlComponents.queryItems ?? [URLQueryItem]()
            mirror.children.forEach { param in
                if let key = param.label {
                    // arrayParam[] syntax
                    if let array = param.value as? [CustomStringConvertible] {
                        array.forEach {
                            queryItems.append(URLQueryItem(name: "\(key)[]", value: "\($0)"))
                        }
                    }
                    queryItems.append(URLQueryItem(name: key, value: "\(param.value)"))
                }
            }
            urlComponents.queryItems = queryItems
            return urlComponents.url?.absoluteString ?? urlString
        }
        return urlString
    }

    internal func buildURLRequest() -> URLRequest? {
        var urlString = baseURL + route
        if httpVerb == .get {
            urlString = getURLWithParams()
        }

        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.cachePolicy = cachePolicy

        if httpVerb != .get && multipartData == nil {
            switch parameterEncoding {
            case .urlEncoded:
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            case .json:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }

        request.httpMethod = httpVerb.rawValue
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let timeout = timeout {
            request.timeoutInterval = timeout
        }

        if httpVerb != .get && multipartData == nil, let params = params {
            switch parameterEncoding {
            case .urlEncoded:
                request.httpBody = percentEncodedString().data(using: .utf8)
            case .json:
                request.httpBody = try? encoder.encode(params)
            }
        }

        // Multipart
        if let multiparts = multipartData {
            // Construct a unique boundary to separate values
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = buildMultipartHttpBody(params: params, multiparts: multiparts, boundary: boundary)
        }
        return request
    }

    private func buildMultipartHttpBody(params: Payload?, multiparts: [MultipartData], boundary: String) -> Data {
        // Combine all multiparts together
        var allMultiparts: [HttpBodyConvertible] = multiparts

        if let params = params {
            do {
                let paramsData = try params.toParams(using: encoder)
                allMultiparts.append(paramsData)
            } catch {
                print(error)
            }
        }

        let boundaryEnding = "--\(boundary)--".data(using: .utf8)!

        // Convert multiparts to boundary-separated Data and combine them
        return allMultiparts
            .map { (multipart: HttpBodyConvertible) -> Data in
                return multipart.buildHttpBodyPart(boundary: boundary)
            }
            .reduce(Data.init(), +)
        + boundaryEnding
    }

    func paramsData() -> [String: Any] {
        do {
            let paramsData = try params.toParams(using: encoder)
            return paramsData
        } catch {
            return [:]
        }
    }

    func percentEncodedString() -> String {
        return paramsData().map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            if let array = value as? [CustomStringConvertible] {
                return array.map { entry in
                    let escapedValue = "\(entry)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
                    return "\(key)[]=\(escapedValue)"
                }.joined(separator: "&")
            } else {
                let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
                return "\(escapedKey)=\(escapedValue)"
            }
        }
        .joined(separator: "&")
    }
}

// Thanks to https://stackoverflow.com/questions/26364914/http-request-in-swift-with-post-method
extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

extension NetworkingRequest {

    class SessionDelegate: NSObject, URLSessionTaskDelegate {

        let progressPublisher: CurrentValueSubject<Progress, NetworkingError>
        let authenticationChallengeHandler: AuthenticationChallengeHandler?

        init(publisher: CurrentValueSubject<Progress, NetworkingError>, authenticationChallengeHandler: AuthenticationChallengeHandler?) {
            self.progressPublisher = publisher
            self.authenticationChallengeHandler = authenticationChallengeHandler
        }

        public func urlSession(_ session: URLSession,
                               task: URLSessionTask,
                               didSendBodyData bytesSent: Int64,
                               totalBytesSent: Int64,
                               totalBytesExpectedToSend: Int64) {
            let progress = Progress(totalUnitCount: totalBytesExpectedToSend)
            progress.completedUnitCount = totalBytesSent
            progressPublisher.send(progress)
        }
        
        public func urlSession(_ session: URLSession,
                        didReceive challenge: URLAuthenticationChallenge,
                        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            authenticationChallengeHandler?(session, challenge, completionHandler)
        }
    }
}

public enum ParameterEncoding {
    case urlEncoded
    case json
}
