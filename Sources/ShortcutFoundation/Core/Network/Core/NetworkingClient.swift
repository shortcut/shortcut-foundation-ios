import Foundation
import Combine

public struct NetworkingClient {
    public var defaultCollectionParsingKeyPath: String?
    let baseURL: String
    public var headers = [String: String]()
    public var parameterEncoding = ParameterEncoding.urlEncoded
    public var timeout: TimeInterval?
    public var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy

    public var decoder: JSONDecoder =  {
        let decoder = JSONDecoder()

        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        decoder.dateDecodingStrategy = .custom { decoder in
            let string = try decoder.singleValueContainer().decode(String.self)
            guard let date = isoFormatter.date(from: string) else {
                throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Could not parse date \(string)"))
            }
            return date
        }

        return decoder
    }()

    public var encoder: JSONEncoder = JSONEncoder()

    private let logger = NetworkingLogger()

    public init(baseURL: String, timeout: TimeInterval? = nil) {
        self.baseURL = baseURL
        self.timeout = timeout
    }
}
