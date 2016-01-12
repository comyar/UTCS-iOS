typealias DataSourceCompletion = (Bool, Bool) -> ()

class DataSource: NSObject {
    var minimumTimeBetweenUpdates: NSTimeInterval = 3600.0
    var updated: NSDate?
    var data: Any!
}
