import Foundation
import UIKit
import SwiftyJSON

class DirectoryDataSourceParser: DataSourceParser {

    func parseValues(values: JSON) -> AnyObject? {
        return parseValues(values)
    }

    func parseValues(values: JSON) -> [DirectoryPerson]? {
        if let jsonArray = values.array {
            return jsonArray.map{DirectoryPerson(json: $0)}.flatMap{$0}
        }
        return nil
    }
}
