
typealias DataSourceCompletion = (Bool, Bool) -> ()

@objc protocol DataSourceDelegate {
    optional func objectsToCacheForDataSource() -> NSDictionary
}

extension DataSourceDelegate {
}

class DataSource: NSObject {
    var minimumTimeBetweenUpdates: NSTimeInterval = 3600.0
    var argument: String?
    var updated: NSDate?
    var data: AnyObject!
    var delegate: DataSourceDelegate?
}