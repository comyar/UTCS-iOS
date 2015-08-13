import SwiftyJSON

typealias DataSourceCompletion = (Bool, Bool) -> ()

@objc protocol DataSourceDelegate {
    optional func objectsToCacheForDataSource() -> NSDictionary
}

extension DataSourceDelegate {

}

class DataSource: NSObject {
    var minimumTimeBetweenUpdates: NSTimeInterval = 3600.0
    let service: Service
    var parser: DataSourceParser!
    var updated: NSDate?
    var data: AnyObject!
    var primaryCacheKey: String?
    var cache: UTCSDataSourceCache
    var delegate: DataSourceDelegate?

    init(service: Service){
        self.service = service
        self.cache = UTCSDataSourceCache(service: service.rawValue)
    }
    init(service: Service, parser: DataSourceParser){
        self.service = service
        self.parser = parser
        self.cache = UTCSDataSourceCache(service: service.rawValue)
    }

    func updateWithArgument(argument: String?, completion: DataSourceCompletion?){
        let cached = cache.objectWithKey(primaryCacheKey!)
        let metaData = cache.objectWithKey(UTCSDataSourceCacheMetaDataName) as? UTCSDataSourceCacheMetaData
        if metaData != nil && NSDate().timeIntervalSinceDate(metaData!.timestamp) < minimumTimeBetweenUpdates{
            data = cache.objectWithKey(UTCSDataSourceCacheValuesName)
            updated = metaData!.timestamp
            completion?(true, true)

            return
        }

        fetchData { (meta, values, error) -> () in
            if let values = values,
                let meta = meta where
                (meta["service"].string == self.service.rawValue && meta["success"].boolValue)  {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) { () -> Void in
                    self.parser.parseValues(values)
                    self.data = self.parser.parsed
                    self.updated = NSDate()
                    dispatch_sync(dispatch_get_main_queue()) { () -> Void in
                        completion?(true, false)

                    }
                }
            }
            else {
                completion?(false, false)
            }
        }

    }
    func fetchData(completion: DataRequestCompletion) {
        fatalError("Data sources must implement fetchData")
    }


}