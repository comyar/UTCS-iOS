import SwiftyJSON
class DiskQuotaDataSourceParser: DataSourceParser {
    var parsedQuota: QuotaData {
        return parsed as! QuotaData
    }
    override func parseValues(values: JSON) {
        parsed = QuotaData(json: values) as! AnyObject
    }
}
