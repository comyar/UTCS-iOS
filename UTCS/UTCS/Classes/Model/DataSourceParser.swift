import SwiftyJSON

protocol DataSourceParser {
    func parseValues(values: JSON) -> Any!
}

let serviceDateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return formatter
}()
