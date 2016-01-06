import Alamofire
import SwiftyJSON

final class DiskQuotaDataSource: ServiceDataSource {
    var quotaData: QuotaData {
        return data as! QuotaData
    }

    override func fetchData(completion: DataRequestCompletion) {
        fatalError("Use the argument form of fetchData")
    }

    func fetchData(username: String, completion: DataRequestCompletion) {
        Alamofire.request(Router.Quota(username: username)).responseJSON { response -> Void in
            guard response.result.isSuccess else {
                // For debugging purposes: Print the raw string
                //let string = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
                completion(nil, nil, response.result.error)
                return
            }
            let swiftyJSON = JSON(response.result.value!)
            completion(swiftyJSON["meta"], swiftyJSON["values"], nil)
            
        }

    }

}
