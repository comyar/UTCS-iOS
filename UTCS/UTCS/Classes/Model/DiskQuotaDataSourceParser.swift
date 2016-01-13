import SwiftyJSON
class DiskQuotaDataSourceParser: DataSourceParser {

    func parseValues(values: JSON) -> AnyObject? {
        return QuotaData(json: values)
    }
}
