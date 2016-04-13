import Foundation

class ServiceCache {
    private(set) var service: Service

    init(service: Service) {
        self.service = service
    }

    func load(argument: String?) -> (ServiceMetadata, AnyObject)? {
        #if DISABLE_CACHE
            return nil
        #endif
        let cacheKey = primaryKey(self.service, argument: argument ?? "")
        guard let fromCache = NSUserDefaults.standardUserDefaults().objectForKey(cacheKey) else {
            return nil
        }

        if let data = fromCache as? NSData,
           asDict = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSDictionary,
           meta = asDict["meta"] as? ServiceMetadata,
           cacheData = asDict["values"] {
            return (meta, cacheData)
        } else {
            clear(argument)
            return nil
        }
    }

    func store(argument: String?, metadata: ServiceMetadata, values: AnyObject) {
        let cacheKey = primaryKey(self.service, argument: argument ?? "")
        let toStore = ["meta": metadata, "values": values]
        let data = NSKeyedArchiver.archivedDataWithRootObject(toStore)
        //print("Caching \(data.length) bytes for \(service.rawValue)")
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: cacheKey)
    }

    func clear(argument: String?) {
        let cacheKey = primaryKey(self.service, argument: argument ?? "")
         NSUserDefaults.standardUserDefaults().removeObjectForKey(cacheKey)
    }

    func primaryKey(service: Service, argument: String) -> String {
        return "\(service.rawValue)_\(argument)"
    }
}
