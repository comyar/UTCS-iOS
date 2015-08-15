import SwiftyJSON

class DataSourceParser {
    var parsed: AnyObject!
    static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()

    func parseValues(values: JSON){
        fatalError("Parsers must implement parseValues")
    }

}