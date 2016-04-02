import UIKit
import Foundation
import SwiftyJSON

@objc class LabMachine: NSObject, NSCoding {
    var lab: String!
    var name: String!
    var load: CGFloat!
    var occupied: Bool
    var status: Bool
    var uptime: String!

    init?(json: JSON, lab: String) {
        guard let name = json["name"].string,
            status = json["up"].bool,
            load = json["load"].float,
        occupied = json["occupied"].bool,
            uptime = json["uptime"].string else {
                return nil
        }
        self.lab = lab
        self.name = name
        self.load = CGFloat(load)
        self.occupied = occupied
        self.status = status
        self.uptime = uptime
    }

    required init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObjectForKey("name") as? String,
         lab = aDecoder.decodeObjectForKey("lab") as? String,
        uptime = aDecoder.decodeObjectForKey("uptime") as? String,
        occupied = aDecoder.decodeObjectForKey("occupied") as? Bool,
        status = aDecoder.decodeObjectForKey("status") as? Bool else {
            return nil
        }
        self.name = name
        self.lab = lab
        self.uptime = uptime
        self.occupied = occupied
        self.status = status
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(lab, forKey: "lab")
        aCoder.encodeObject(uptime, forKey: "uptime")
        aCoder.encodeObject(load, forKey: "load")
        aCoder.encodeObject(occupied, forKey: "occupied")
        aCoder.encodeObject(status, forKey: "status")
    }
}