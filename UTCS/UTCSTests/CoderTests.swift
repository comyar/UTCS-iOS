import XCTest
import SwiftyJSON
@testable import UTCS

class CoderTests: XCTestCase {

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
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDiskQuotaCoder(){
        guard let values = responses[.DiskQuota]?["values"],
            fromJSON = QuotaData(json: values) else {
            XCTFail()
                return
        }
        let archive = NSKeyedArchiver.archivedDataWithRootObject(fromJSON)
        guard let unarchived = NSKeyedUnarchiver.unarchiveObjectWithData(archive) as? QuotaData else {
            XCTFail()
            return
        }

        XCTAssertEqual(fromJSON, unarchived)

    }

    func testEventsCoder(){
        guard let values = responses[.Events]?["values"],
            fromJSON = Event(json: values[0]) else {
                XCTFail()
                return
        }
        let archive = NSKeyedArchiver.archivedDataWithRootObject(fromJSON)
        guard let unarchived = NSKeyedUnarchiver.unarchiveObjectWithData(archive) as? Event else {
            XCTFail()
            return
        }

        XCTAssertEqual(fromJSON, unarchived)
        
    }
}
