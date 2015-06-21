class DiskQuotaDataSourceParser: UTCSDataSourceParser {
    override func parseValues(values: AnyObject!) -> AnyObject! {
        var values = values as! [String: AnyObject]
        var parsed = [String: AnyObject]()
        for (key, _) in values {
            if values[key] != nil {
                parsed[key] = values[key]
            }
        }
        return parsed
    }
}
