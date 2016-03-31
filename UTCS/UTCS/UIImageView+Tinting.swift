//
//  UIImageView+Tinting.swift
//  UTCS
//
//  Created by Jesse Tipton on 3/31/16.
//  Copyright © 2016 UTCS. All rights reserved.
//

import UIKit

extension UIImageView {
    
    @IBInspectable var appliedTintColor: UIColor {
        get {
            return tintColor
        }
        set {
            tintColor = newValue
            image = image?.imageWithRenderingMode(.AlwaysTemplate)
        }
    }
    
}
