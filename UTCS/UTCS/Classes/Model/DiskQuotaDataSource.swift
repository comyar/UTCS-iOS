final class DiskQuotaDataSource: ServiceDataSource {
    var quotaData: QuotaData {
        return data as! QuotaData
    }
    override var router: Router {
        return Router.Quota(username: argument ?? "")
    }

}
