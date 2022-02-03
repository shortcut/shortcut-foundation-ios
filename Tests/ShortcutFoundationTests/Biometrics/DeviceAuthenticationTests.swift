import XCTest
import Combine

@testable import ShortcutFoundation

class DeviceAuthenticationTests: XCTestCase {
    
    private let timeout: TimeInterval = 5.0
    private let dispatchDelay = 0.5

    private var cancelleables = Set<AnyCancellable>()

    func test_no_device_biometrics() {
        let context = MockDeviceContext()
        let deviceAuth = DeviceAuthentication(context: context,
                                              localizedAlertDesc: "test device biometrics is none")
        XCTAssertEqual(deviceAuth.type, .none)
        XCTAssertFalse(deviceAuth.isBiometricsSupported)
    }

    func test_faceID_support() {
        let context = MockDeviceContext(type: .faceID)
        let deviceAuth = DeviceAuthentication(context: context,
                                              localizedAlertDesc: "test faceID biometrics")
        
        XCTAssertEqual(deviceAuth.type, .faceID)
        XCTAssertTrue(deviceAuth.isBiometricsSupported)
    }

    func test_touchID_support() {
        let context = MockDeviceContext(type: .touchID)
        let deviceAuth = DeviceAuthentication(context: context,
                                      localizedAlertDesc: "test touchID biometrics")
        XCTAssertEqual(deviceAuth.type, .touchID)
        XCTAssertTrue(deviceAuth.isBiometricsSupported)
    }

    func test_login_no_ID() {
        let context = MockDeviceContext()
        let deviceAuth = DeviceAuthentication(context: context,
                                              localizedAlertDesc: "test biometrics unavailable")
        
        XCTAssertEqual(deviceAuth.action, .notAuthenticated)
        
        let expect = expectation(description: "expect")
        deviceAuth.$action
            .dropFirst()
            .sink { action in
                switch action {
                case let .error(error):
                    switch error {
                    case .unsupportedDevice:
                        expect.fulfill()
                    default:
                        XCTFail("Unexpected result")
                    }
                    
                default:
                    XCTFail("Unexpected result")
                }
            }
            .store(in: &cancelleables)
        
        deviceAuth.login()
        
        waitForExpectations(timeout: timeout, handler: nil)
    }

    func test_login_faceID() {
        let context = MockDeviceContext(type: .faceID, isAuthenticated: true)
        let deviceAuth = DeviceAuthentication(context: context,
                                              localizedAlertDesc: "loginWithFaceID")
        
        
        XCTAssertEqual(deviceAuth.action, .notAuthenticated)

        let expect = expectation(description: "expect")
        deviceAuth.$action
            .dropFirst()
            .sink { action in
                switch action {
                case .authenticated:
                    expect.fulfill()

                default:
                    XCTFail("Unexpected result")
                }
            }
            .store(in: &cancelleables)

        deviceAuth.login()

        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_login_faceID_failed() {
        let context = MockDeviceContext(type: .faceID)
        let deviceAuth = DeviceAuthentication(context: context,
                                              localizedAlertDesc: "loginWithFaceID")
        
        
        XCTAssertEqual(deviceAuth.action, .notAuthenticated)

        let expect = expectation(description: "expect")
        deviceAuth.$action
            .dropFirst()
            .sink { action in
                switch action {
                case let .error(error):
                    switch error {
                    case .failed:
                        expect.fulfill()

                    default:
                        XCTFail("Unexpected result")
                    }

                default:
                    XCTFail("Unexpected result")
                }
            }
            .store(in: &cancelleables)

        deviceAuth.login()

        waitForExpectations(timeout: timeout, handler: nil)
    }

    func test_login_touchID() {
        let context = MockDeviceContext(type: .touchID, isAuthenticated: true)
        let deviceAuth = DeviceAuthentication(context: context,
                                              localizedAlertDesc: "loginWithTouchID")
        
        XCTAssertEqual(deviceAuth.action, .notAuthenticated)

        let expect = expectation(description: "expect")
        deviceAuth.$action
            .dropFirst()
            .sink { action in
                switch action {
                case .authenticated:
                    expect.fulfill()

                default:
                    XCTFail("Unexpected result")
                }
            }
            .store(in: &cancelleables)

        deviceAuth.login()

        waitForExpectations(timeout: timeout, handler: nil)
    }

    func test_repeat_login_touchID() {
        let context = MockDeviceContext(type: .touchID,
                                        isAuthenticated: true)
        let deviceAuth = DeviceAuthentication(context: context,
                                              localizedAlertDesc: "loginWithTouchID")
        XCTAssertEqual(deviceAuth.action, .notAuthenticated)

        let expect = expectation(description: "expect")
        deviceAuth.$action
            .dropFirst(3)
            .sink { action in
                switch action {
                case .authenticated:
                    expect.fulfill()

                default:
                    XCTFail("Unexpected result")
                }
            }
            .store(in: &cancelleables)

        deviceAuth.login()
        // The response is queued on main and requires a delay to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + dispatchDelay) {
            deviceAuth.login()
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }

    

    func test_logout() {
        let context = MockDeviceContext(type: .touchID, isAuthenticated: true)
        let deviceAuth = DeviceAuthentication(context: context,
                                              localizedAlertDesc: "loginWithTouchID")
        XCTAssertEqual(deviceAuth.action, .notAuthenticated)

        let expect = expectation(description: "expect")
        deviceAuth.$action
            .dropFirst(2)
            .sink { action in
                switch action {
                case .notAuthenticated:
                    expect.fulfill()

                default:
                    XCTFail("Unexpected result")
                }
            }
            .store(in: &cancelleables)

        deviceAuth.login()
        DispatchQueue.main.asyncAfter(deadline: .now() + dispatchDelay) {
            deviceAuth.logout()
        }

        waitForExpectations(timeout: timeout, handler: nil)
    }

    func test_logout_failed() {
        let context = MockDeviceContext(type: .touchID, isAuthenticated: true)
        let deviceAuth = DeviceAuthentication(context: context,
                                              localizedAlertDesc: "logout")
        XCTAssertEqual(deviceAuth.action, .notAuthenticated)

        deviceAuth.$action
            .dropFirst()
            .sink { _ in
                XCTFail("Unexpected result")
            }
            .store(in: &cancelleables)

        deviceAuth.logout()
        XCTAssertEqual(deviceAuth.action, .notAuthenticated)
    }
}
