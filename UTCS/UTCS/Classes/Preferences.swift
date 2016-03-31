//
//  Preferences.swift
//  UTCS
//
//  Created by Jesse Tipton on 3/31/16.
//  Copyright © 2016 UTCS. All rights reserved.
//

enum ComputerLab: Int {
    case ThirdFloor, Basement
}

struct Preferences {
    
    private static let EVENT_NOTIFICATIONS_KEY = "event_notifications"
    private static let PREFERRED_LAB_KEY = "preferred_lab"
    
    static var starredEventNotificationsEnabled: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(Preferences.EVENT_NOTIFICATIONS_KEY)
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: Preferences.EVENT_NOTIFICATIONS_KEY)
        }
    }
    
    static var preferredLab: ComputerLab {
        get {
            return ComputerLab(rawValue: NSUserDefaults.standardUserDefaults().integerForKey(Preferences.PREFERRED_LAB_KEY))!
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue.rawValue, forKey: Preferences.PREFERRED_LAB_KEY)
        }
    }

}
