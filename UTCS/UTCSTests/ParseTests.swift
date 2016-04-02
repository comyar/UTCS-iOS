import XCTest
import SwiftyJSON
@testable import UTCS

class ParseTests: XCTestCase {
    var responses: [Service: JSON] = [:]
    override func setUp() {
        super.setUp()
        let bundle = NSBundle(forClass: self.dynamicType)
        for service in Service.allValues {
            let serviceName = service.rawValue
            let fileLocation = bundle.pathForResource(serviceName, ofType: "json")!
            let text: String
            do {
                text = try String(contentsOfFile: fileLocation)
            } catch {
                fatalError()
            }
            if let dataFromString = text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                let json = JSON(data: dataFromString)
                responses[service] = json
            } else {
                fatalError()
            }

        }
    }

    func testEventsParsing(){
        guard let values = responses[.Events]?["values"],
            events: [Event] = EventsDataSourceParser().parseValues(values) else {
            XCTFail()
            return
        }
        XCTAssertEqual(events.count, 148)
    }

    func testDiskQuotaParsing(){
        guard let values = responses[.DiskQuota]?["values"],
        quotaData: QuotaData = DiskQuotaDataSourceParser().parseValues(values) else {
            XCTFail()
            return
        }
        XCTAssertEqual(quotaData.limit, 2048)
        XCTAssertEqual(quotaData.name, "Nicholas Walker")
        XCTAssertTrue(quotaData.usage - 1236.079 < 0.01)
        XCTAssertEqual(quotaData.user, "nwalker")
    }

    func testNewsParsing(){
        guard let values = responses[.News]?["values"],
            articles: [NewsArticle] = NewsDataSourceParser().parseValues(values) else {
            XCTFail()
            return
        }
        XCTAssertEqual(articles.count, 10)
    }

    func testLabsParsing(){
        guard let values = responses[.Labs]?["values"],
            labs: [String: Lab] = LabsDataSourceParser().parseValues(values),
            third = labs["third"],
            basement = labs["basement"] else {
            XCTFail()
            return
        }
        XCTAssertEqual(labs.count, 2)

        XCTAssertEqual(third.count, 88)
        XCTAssertEqual(basement.count, 77)
    }



}
