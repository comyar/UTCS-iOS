import XCTest
@testable import UTCS

class UTCSTests: XCTestCase {
    
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
        let digest = DataRequest.createDigest("test", argument: "test")
        XCTAssert( digest == iosTestDigest)
    }
    
    
}
