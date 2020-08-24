import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(uplink_swiftTests.allTests)
    ]
}
#endif
