import Foundation

class DataSourceCache {
    private(set) var service: Service

    init(service: Service) {
        self.service = service
    }

    func load(argument: String?) -> (DataSourceCacheMetaData, [NSObject: AnyObject?])? {
        let cacheKey = primaryKey(self.service, argument: argument ?? "")
        let data = NSUserDefaults.standardUserDefaults().objectForKey(cacheKey)
        if let toProcess = data as? NSData,
           let asDict = NSKeyedUnarchiver.unarchiveObjectWithData(toProcess),
           let meta = asDict["meta"] as? DataSourceCacheMetaData,
           let cacheData = asDict["values"] as? [NSObject: AnyObject?] {
            return (meta, cacheData)
        } else {
            return nil
        }
    }

    func primaryKey(service: Service, argument: String) -> String {
        return "\(service.rawValue)_\(argument)"
    }
}
