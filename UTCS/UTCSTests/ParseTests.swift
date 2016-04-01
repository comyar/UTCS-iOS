import XCTest
import SwiftyJSON
@testable import UTCS

class ParseTests: XCTestCase {
    var responses: [Service: JSON] = [:]
    override func setUp() {
        super.setUp()
        for service in Service.allValues {
            let serviceName = service.rawValue
            let fileLocation = NSBundle(forClass: self.dynamicType).pathForResource(serviceName, ofType: "json")!
            let text: String
            do {
                text = try String(contentsOfFile: fileLocation)
            } catch {
                text = ""
            }
            if let dataFromString = text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                let json = JSON(data: dataFromString)
                responses[service] = json
            } else {
                fatalError()
            }

        }
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEventsParsing(){
        guard let events: [Event] = EventsDataSourceParser().parseValues(responses[.Events]!) else {
            XCTFail()
            return
        }
        XCTAssertEqual(events.count, 10)
    }

}
