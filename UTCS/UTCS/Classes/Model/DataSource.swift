typealias DataSourceCompletion = (Bool, Bool) -> ()

@objc protocol DataSourceDelegate {
    optional func objectsToCacheForDataSource() -> NSDictionary
}

extension DataSourceDelegate {

}

class DataSource: NSObject {
    var minimumTimeBetweenUpdates: NSTimeInterval = 3600.0
    let service: Service
    var parser: UTCSDataSourceParser!
    var updated: NSDate?
    var data: AnyObject!
    var primaryCacheKey: String?
    var cache: [NSObject: AnyObject]
    var delegate: DataSourceDelegate?

    init(service: Service){
        self.service = service
    }
    init(service: Service, parser: UTCSDataSourceParser){
        self.service = service
        self.parser = parser
    }

    func updateWithArgument(argument: String?, completion: DataSourceCompletion?){
        let cached = cache[primaryCacheKey!]
        let metaData = cache[UTCSDataSourceCacheMetaDataName] as? UTCSDataSourceCacheMetaData
        if metaData != nil && NSDate().timeIntervalSinceDate(metaData!.timestamp) < minimumTimeBetweenUpdates{
            data = cache[UTCSDataSourceCacheValuesName]
            updated = metaData!.timestamp
            completion?(true, true)

            return
        }

        fetchData { (meta, values, error) -> () in
            if meta["service"] as! String == self.service.rawValue && meta["success"] as! Bool {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) { () -> Void in
                    self.data = self.parser.parseValues(values)
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
        ()
    }


}