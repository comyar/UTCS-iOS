import Foundation
import UIKit
import SwiftyJSON

class ServiceMetadata: NSObject, NSCoding {
    var service: Service!
    var updated: NSDate!
    var success: Bool!

    init?(json: JSON) {
        super.init()
        if let serviceString = json["service"].string,
           service = Service(rawValue: serviceString),
           updatedString = json["updated"].string,
           updated = serviceDateFormatter.dateFromString(updatedString),
           success = json["success"].bool {
                self.service = service
                self.updated = updated
                self.success = success
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init()
        if let service = aDecoder.decodeObjectForKey("service") as? String,
            let updated = aDecoder.decodeObjectForKey("updated") as? NSDate{
                self.service = Service(rawValue: service)!
                self.updated = updated
                self.success = aDecoder.decodeBoolForKey("success")
                return
        } else {
            return nil
        }
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(service.rawValue, forKey: "service")
        aCoder.encodeObject(updated, forKey: "updated")
        aCoder.encodeBool(success, forKey: "success")
    }
}
