//
//  HTML.swift
//  UTCS
//
//  Created by Jesse Tipton on 4/7/16.
//  Copyright © 2016 UTCS. All rights reserved.
//

import Foundation
import UIKit

extension String {
 
    func sanitizeHTML() -> String {
        let encodedData = dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions: [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
        ]
        do {
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            let decodedString = attributedString.string
            return decodedString
        } catch {
            return self
        }
    }
    
}
