import SwiftyJSON
class DiskQuotaDataSourceParser: DataSourceParser {
    override func parseValues(values: JSON) {
        let quotaData = QuotaData()
        quotaData.limit = values["limit"].int
        quotaData.usage = values["usage"].double
        quotaData.user = values["user"].string
        quotaData.name = values["name"].string
        parsed = quotaData
    }
}
