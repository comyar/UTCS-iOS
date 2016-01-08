import SwiftyJSON
class DiskQuotaDataSourceParser: DataSourceParser {

    func parseValues(values: JSON) -> Any! {
        return QuotaData(json: values)
    }
}
