//
//  UTCSLabMachine.swift
//  UTCS
//
//  Created by Taylor Schmidt on 4/6/16.
//  Copyright © 2016 UTCS. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UTCSLabMachineKey {
    static let labKey      = "lab"
    static let nameKey     = "name"
    static let uptimeKey   = "uptime"
    static let statusKey   = "up"
    static let occupiedKey = "occupied"
    static let loadKey     = "load"
}

class UTCSLabMachine : NSObject, NSCoding {
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
        guard let name = json[UTCSLabMachineKey.nameKey].string,
            status = json[UTCSLabMachineKey.statusKey].bool,
            load = json[UTCSLabMachineKey.loadKey].double,
        occupied = json[UTCSLabMachineKey.occupiedKey].bool,
            uptime = json[UTCSLabMachineKey.uptimeKey].string else {
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
        let aLab = aDecoder.decodeObjectForKey(UTCSLabMachineKey.labKey) as! String
        let aName = aDecoder.decodeObjectForKey(UTCSLabMachineKey.nameKey) as! String
        let aUptime = aDecoder.decodeObjectForKey(UTCSLabMachineKey.uptimeKey) as! String
        let aStatus = aDecoder.decodeBoolForKey(UTCSLabMachineKey.statusKey)
        let aOccupied = aDecoder.decodeBoolForKey(UTCSLabMachineKey.occupiedKey)
        let aLoad = aDecoder.decodeDoubleForKey(UTCSLabMachineKey.loadKey)
        self.init(lab: aLab, name: aName, uptime: aUptime, status: aStatus, occupied: aOccupied, load: aLoad)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.lab, forKey: UTCSLabMachineKey.labKey)
        aCoder.encodeObject(self.name, forKey: UTCSLabMachineKey.nameKey)
        aCoder.encodeObject(self.uptime, forKey: UTCSLabMachineKey.uptimeKey)
        aCoder.encodeBool(self.status, forKey: UTCSLabMachineKey.statusKey)
        aCoder.encodeBool(self.occupied, forKey: UTCSLabMachineKey.occupiedKey)
        aCoder.encodeDouble(self.load, forKey: UTCSLabMachineKey.loadKey)
    }
}