//
//  UIApplication+Version.swift
//  UTCS
//
//  Created by Jesse Tipton on 3/30/16.
//  Copyright © 2016 UTCS. All rights reserved.
//

import UIKit

extension UIApplication {
    
    var version: String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
    }
    
    var build: String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as! String
    }
    
}
