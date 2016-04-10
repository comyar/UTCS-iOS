import SwiftyJSON
class DiskQuotaDataSourceParser: DataSourceParser {

    func parseValues(values: JSON) -> AnyObject? {
        // Need this so we don't have any ambiguity
        let quotaData: QuotaData? = parseValues(values)
        return quotaData
    }

    func parseValues(values: JSON) -> QuotaData? {
        return QuotaData(json: values)
    }
}
