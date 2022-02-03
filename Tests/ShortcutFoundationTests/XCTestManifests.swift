import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(InjectionTests.allTests),
        estCase(DeviceAuthenticationTests.allTests),
    ]
}
#endif
