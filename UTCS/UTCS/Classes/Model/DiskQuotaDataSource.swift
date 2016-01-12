import Alamofire
import SwiftyJSON

final class DiskQuotaDataSource: ServiceDataSource {
    var quotaData: QuotaData {
        return data as! QuotaData
    }
    override var router: Router {
        return currentRouter
    }
    private var currentRouter = Router.Quota(username: "")

    override func updateWithArgument(argument: String?, completion: DataSourceCompletion?) {
        configureRouter(argument!)
        super.updateWithArgument(argument, completion: completion)
    }

    private func configureRouter(userName: String) {
        currentRouter = Router.Quota(username: userName)
    }

}
