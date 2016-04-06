//
//  UTCSLabViewLayoutAttributes.swift
//  UTCS
//
//  Created by Taylor Schmidt on 4/6/16.
//  Copyright © 2016 UTCS. All rights reserved.
//

import Foundation

class UTCSLabViewLayoutAttributes {
    var size: CGSize
    var center: CGPoint
    var indexPath: NSIndexPath
    
    init(size: CGSize, center: CGPoint, indexPath: NSIndexPath) {
        self.size = size
        self.center = center
        self.indexPath = indexPath
    }
}