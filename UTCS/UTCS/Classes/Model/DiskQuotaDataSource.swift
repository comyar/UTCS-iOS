final class DiskQuotaDataSource: DataSource {
    var quotaData: QuotaData {
    get{
    return data as! QuotaData
    }
    }
    override var router: Router {
        get{
            return Router.Quota(username: argument ?? "")
        }
    }

}