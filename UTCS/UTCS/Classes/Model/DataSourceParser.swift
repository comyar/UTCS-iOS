import SwiftyJSON

class DataSourceParser {
    var parsed: AnyObject!
    let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()

    func parseValues(values: JSON){
        
    }

}