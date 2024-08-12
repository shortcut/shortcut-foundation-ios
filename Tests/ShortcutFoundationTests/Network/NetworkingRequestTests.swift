//
//  NetworkingRequestTests.swift
//  
//
//  Created by Karl Söderberg on 2024-08-12.
//

import XCTest
@testable import ShortcutFoundation

final class NetworkingRequestTests: XCTestCase {

    struct MyPayload: Encodable {
        let name: String
        let age: Int
    }

    func testURL() throws {
        let url = URL(string: "www.google.com")!
        let request = NetworkingRequest<String>()
        request.baseURL = "www.google.com"
        let urlRequest = request.buildURLRequest()
        XCTAssertEqual(urlRequest?.url, url)
    }

    func testURLWithQueryParams() throws {
        let payload = MyPayload(name: "Kalle", age: 38)

        let request = NetworkingRequest<MyPayload>()
        request.baseURL = "www.google.com"
        request.params = payload
        let urlRequest = request.buildURLRequest()

        let url = URL(string: "www.google.com?name=Kalle&age=38")!
        XCTAssertEqual(urlRequest?.url, url)
    }

    func testURLShouldNotHaveQueryParamsIfPost() throws {
        let payload = MyPayload(name: "Kalle", age: 38)

        let request = NetworkingRequest<MyPayload>()
        request.baseURL = "www.google.com"
        request.params = payload
        request.httpVerb = .post
        let urlRequest = request.buildURLRequest()

        let url = URL(string: "www.google.com")!
        XCTAssertEqual(urlRequest?.url, url)
    }
}
