import Foundation
import SwiftyJSON

struct LabMachineKey {
    static let labKey      = "lab"
    static let nameKey     = "name"
    static let uptimeKey   = "uptime"
    static let statusKey   = "up"
    static let occupiedKey = "occupied"
    static let loadKey     = "load"
}

class LabMachine : NSObject, NSCoding {
    let lab: String
    let name: String
    let uptime: String
    let status: Bool
    let occupied: Bool
    let load: Double
    
    init?(lab: String, name: String, uptime: String, status: Bool, occupied: Bool, load: Double) {
        self.lab = lab
        self.name = name
        self.uptime = uptime
        self.status = status
        self.occupied = occupied
        self.load = load
        super.init()
    }
    
    init?(json: JSON, lab: String) {
        guard let name = json[LabMachineKey.nameKey].string,
            status = json[LabMachineKey.statusKey].bool,
            load = json[LabMachineKey.loadKey].double,
        occupied = json[LabMachineKey.occupiedKey].bool,
            uptime = json[LabMachineKey.uptimeKey].string else {
                return nil
        }
        self.lab = lab
        self.name = name
        self.load = load
        self.occupied = occupied
        self.status = status
        self.uptime = uptime
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let aLab = aDecoder.decodeObjectForKey(LabMachineKey.labKey) as! String
        let aName = aDecoder.decodeObjectForKey(LabMachineKey.nameKey) as! String
        let aUptime = aDecoder.decodeObjectForKey(LabMachineKey.uptimeKey) as! String
        let aStatus = aDecoder.decodeBoolForKey(LabMachineKey.statusKey)
        let aOccupied = aDecoder.decodeBoolForKey(LabMachineKey.occupiedKey)
        let aLoad = aDecoder.decodeDoubleForKey(LabMachineKey.loadKey)
        self.init(lab: aLab, name: aName, uptime: aUptime, status: aStatus, occupied: aOccupied, load: aLoad)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.lab, forKey: LabMachineKey.labKey)
        aCoder.encodeObject(self.name, forKey: LabMachineKey.nameKey)
        aCoder.encodeObject(self.uptime, forKey: LabMachineKey.uptimeKey)
        aCoder.encodeBool(self.status, forKey: LabMachineKey.statusKey)
        aCoder.encodeBool(self.occupied, forKey: LabMachineKey.occupiedKey)
        aCoder.encodeDouble(self.load, forKey: LabMachineKey.loadKey)
    }
}