import SwiftyJSON
class DiskQuotaDataSourceParser: DataSourceParser {
    override func parseValues(values: JSON) {
        var values = values as! [String: AnyObject]
        var parsed = [String: AnyObject]()
        for (key, _) in values {
            if values[key] != nil {
                parsed[key] = values[key]
            }
        }
    }
}
