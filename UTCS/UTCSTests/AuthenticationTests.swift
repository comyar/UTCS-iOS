import XCTest
@testable import UTCS

class AuthenticationTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDigest() {
        // HMAC using the iOS key and "testtest"
        let iosTestDigest = "9113d275a801c496202b2600e10d40bdd0acfd54"
        let digest = Router.createDigest("test", argument: "test")
        XCTAssert( digest == iosTestDigest)
    }

    func testDateParsing() {
        // Backend returns ISO8601 dates
        let testString = "2015-01-29T23:59:59+00:00"
        let result = serviceDateFormatter.dateFromString(testString)
        XCTAssertNotNil(result)
        let components = NSDateComponents()
        components.setValue(2015, forComponent: .Year)
        components.setValue(1, forComponent: .Month)
        components.setValue(29, forComponent: .Day)
        components.setValue(23, forComponent: .Hour)
        components.setValue(59, forComponent: .Minute)
        components.setValue(59, forComponent: .Second)
        let calendar = NSCalendar.currentCalendar()
        calendar.timeZone = NSTimeZone(abbreviation: "UTC")!
        XCTAssertEqual(result!, calendar.dateFromComponents(components)!)
    }


}
