import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ExceptionHandlerTests.allTests),
    ]
}
#endif
