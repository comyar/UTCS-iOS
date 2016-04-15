//
//  UTCSLabViewLayoutAttributes.swift
//  UTCS
//
//  Created by Taylor Schmidt on 4/6/16.
//  Copyright © 2016 UTCS. All rights reserved.
//

import Foundation
import UIKit
func ==(lhs: UTCSLabViewLayoutAttributes, rhs: UTCSLabViewLayoutAttributes) -> Bool {
    return lhs.center == rhs.center && lhs.size == rhs.size && lhs.indexPath == rhs.indexPath
}

class UTCSLabViewLayoutAttributes {
    var size: CGSize
    var center: CGPoint
    var indexPath: NSIndexPath
    
    init (size: CGSize, center: CGPoint, indexPath: NSIndexPath) {
        self.size = size
        self.center = center
        self.indexPath = indexPath
    }
}