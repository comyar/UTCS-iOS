import Alamofire
import SwiftyJSON

public enum Service: String {
    case Labs = "labs"
    case DiskQuota = "quota"
    case Events = "events"
    case News = "news"
    case Directory = "directory"
}

class ServiceDataSource: DataSource {
    var parser: DataSourceParser!
    let service: Service
    var cache: DataSourceCache!
    var router: Router {
        fatalError("Subclasses must provide their own Routers")
    }

    init(service: Service) {
        self.service = service
        self.cache = DataSourceCache(service: service)
    }

    init(service: Service, parser: DataSourceParser) {
        self.service = service
        self.parser = parser
        self.cache = DataSourceCache(service: service)
    }

    private func hasMinimumTimeElapsed(since: NSDate) -> Bool {
        return true
    }

    func updateWithArgument(argument: String?, completion: DataSourceCompletion?) {
        // Attempt to load from cache
        if let (cacheMeta, cacheValues) = cache.load(argument) where hasMinimumTimeElapsed(cacheMeta.timestamp) {
            updated = cacheMeta.timestamp
            data = cacheValues as! AnyObject
            completion?(true, true)
        }

        fetchData { (meta, values, error) -> () in
            if let values = values,
                let meta = meta where
                (meta["service"].string == self.service.rawValue && meta["success"].boolValue) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) { () -> Void in

                        self.data = self.parser.parseValues(values)
                        self.updated = NSDate()
                        dispatch_sync(dispatch_get_main_queue()) { () -> Void in
                            completion?(true, false)

                        }
                    }
            } else {
                completion?(false, false)
            }
        }

    }

    func fetchData(completion: DataRequestCompletion) {
        Alamofire.request(router).responseJSON { response -> Void in
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
