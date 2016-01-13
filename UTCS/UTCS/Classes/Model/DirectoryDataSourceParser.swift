import Foundation
import UIKit
import SwiftyJSON

class DirectoryDataSourceParser: DataSourceParser {

    func parseValues(values: JSON) -> AnyObject? {
        if let jsonArray = values.array {
            return jsonArray.map{DirectoryPerson(json: $0)}.flatMap{$0}
        } else {
            return nil
        }
    }
}
