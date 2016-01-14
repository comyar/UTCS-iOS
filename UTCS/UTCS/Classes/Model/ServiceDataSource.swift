import Alamofire
import SwiftyJSON

public enum Service: String {
    case Labs = "labs"
    case DiskQuota = "quota"
    case Events = "events"
    case News = "news"
    case Directory = "directory"

    func cacheExpirationTime() -> NSTimeInterval{
        switch self {
        case .Labs:
            return 30
        case .DiskQuota:
            return 30
        case .Events:
            return 3600 * 24
        case .News:
            return 3600 * 24
        case .Directory:
            return 3600 * 24 * 7
        }
    }

    func cacheExpired(metadata: ServiceMetadata) -> Bool {
        let expiryTime = self.cacheExpirationTime()
        let expiryDate = metadata.updated.dateByAddingTimeInterval(expiryTime)
        return NSDate().compare(expiryDate) == .OrderedDescending
    }
}

typealias DataSourceCompletion = (ServiceDataSource.UpdateResult) -> ()

class ServiceDataSource: NSObject {
    var data: AnyObject!
    var parser: DataSourceParser!
    let service: Service
    var cache: ServiceCache!
    
    var updated: NSDate?
    var router: Router {
        fatalError("Subclasses must provide their own Routers")
    }

    enum UpdateResult {
        case Failed,
        SuccessFresh,
        SuccessFromCache

        var successful: Bool {
            return self == .SuccessFromCache || self == .SuccessFresh
        }
    }

    init(service: Service) {
        self.service = service
        self.cache = ServiceCache(service: service)
    }

    init(service: Service, parser: DataSourceParser) {
        self.service = service
        self.parser = parser
        self.cache = ServiceCache(service: service)
    }

    func updateWithArgument(argument: String?, completion: DataSourceCompletion?) {
        // Attempt to load from cache
        let fromCache = cache.load(argument)
        if let (cacheMeta, cacheValues) = fromCache {
            print("Cache available")
            if !cacheMeta.service.cacheExpired(cacheMeta){
                updated = cacheMeta.updated
                data = cacheValues
                completion?(.SuccessFromCache)
                return
            }
        }

        fetchData { (meta, values, error) -> () in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                let result: UpdateResult
                // Make sure the response makes sense
                if let values = values,
                    meta = meta,
                    parsedMeta = ServiceMetadata(json: meta),
                    parsed = self.parser.parseValues(values)
                    where parsedMeta.service == self.service {
                    // Cache the response
                    self.cache.store(argument, metadata: parsedMeta, values: parsed)
                    self.data = parsed
                    result = .SuccessFresh
                } else if let (_, cacheValues) = fromCache {
                    self.data = cacheValues
                    result = .SuccessFromCache
                } else {
                    result = .Failed
                }
                self.updated = NSDate()
                dispatch_sync(dispatch_get_main_queue()) {
                    completion?(result)
                }
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
