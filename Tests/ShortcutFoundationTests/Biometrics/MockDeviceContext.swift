#if canImport(LocalAuthentication)
import Foundation
import LocalAuthentication
import ShortcutFoundation

#if !os(watchOS) && !os(tvOS)
public final class MockDeviceContext: DeviceContextProtocol {
    
    private let type: LABiometryType

    public var mockEvaluateReply: (Bool, Error?) = (false, nil)

    public var biometryType: LABiometryType { type }

    public var localizedCancelTitle: String?

    public init(type: LABiometryType = .none,
                isAuthenticated: Bool = false) {
        self.type = type
        if isAuthenticated {
            mockEvaluateReply = (true, nil)
        }
    }

    public func canEvaluatePolicy(_: LAPolicy,
                                  error _: NSErrorPointer) -> Bool {
        type != .none
    }

    public func evaluatePolicy(_: LAPolicy,
                               localizedReason _: String,
                               reply: @escaping (Bool, Error?) -> Void) {
        reply(mockEvaluateReply.0, mockEvaluateReply.1)
    }
}
#endif
#endif
