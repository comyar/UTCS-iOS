//
//  NSAttributedString+Trim.swift
//  UTCS
//
//  Created by Jesse Tipton on 3/25/16.
//  Copyright © 2016 UTCS. All rights reserved.
//

import Foundation

extension NSAttributedString {

    func attributedStringByTrimmingCharactersInSet(set: NSCharacterSet) -> NSAttributedString {
        let trimmedString = string.stringByTrimmingCharactersInSet(set)
        let baseString = string as NSString
        let range = baseString.rangeOfString(trimmedString)
        return attributedSubstringFromRange(range)
    }
    
}
