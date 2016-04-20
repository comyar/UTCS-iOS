//
//  Preferences.swift
//  UTCS
//
//  Created by Jesse Tipton on 3/31/16.
//  Copyright © 2016 UTCS. All rights reserved.
//
import Foundation
enum ComputerLab: Int {
    case ThirdFloor, Basement
}

struct Preferences {
    
    private static let PREFERRED_LAB_KEY = "preferred_lab"
    
    static var preferredLab: ComputerLab {
        get {
            return ComputerLab(rawValue: NSUserDefaults.standardUserDefaults().integerForKey(Preferences.PREFERRED_LAB_KEY))!
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue.rawValue, forKey: Preferences.PREFERRED_LAB_KEY)
        }
    }

}
