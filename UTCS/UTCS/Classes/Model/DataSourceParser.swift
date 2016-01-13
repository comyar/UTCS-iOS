import SwiftyJSON

protocol DataSourceParser {
    func parseValues(values: JSON) -> AnyObject?
}

let serviceDateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return formatter
}()
