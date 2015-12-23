import Alamofire
import SwiftyJSON

class ServiceDataSource: DataSource {
    var parser: DataSourceParser!
    let service: Service
    var cache: UTCSDataSourceCache!
    var router: Router {
        get {
            fatalError("Subclasses must provide their own Routers")
        }
    }

    init(service: Service){
        self.service = service
        self.cache = UTCSDataSourceCache(service: service.rawValue)
    }
    init(service: Service, parser: DataSourceParser) {
        self.service = service
        self.parser = parser
        self.cache = UTCSDataSourceCache(service: service.rawValue)
    }

    func updateWithArgument(argument: String?, completion: DataSourceCompletion?) {
        self.argument = argument
        let metaData = cache.objectWithKey(UTCSDataSourceCacheMetaDataName) as? UTCSDataSourceCacheMetaData
        if metaData != nil && NSDate().timeIntervalSinceDate(metaData!.timestamp) < minimumTimeBetweenUpdates {
            data = cache.objectWithKey(UTCSDataSourceCacheValuesName)
            updated = metaData!.timestamp
            completion?(true, true)

            return
        }

        fetchData { (meta, values, error) -> () in
            if let values = values,
                let meta = meta where
                (meta["service"].string == self.service.rawValue && meta["success"].boolValue) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) { () -> Void in
                        self.parser.parseValues(values)
                        self.data = self.parser.parsed
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
