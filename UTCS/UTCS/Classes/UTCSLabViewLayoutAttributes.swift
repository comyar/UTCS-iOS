//
//  UTCSLabViewLayoutAttributes.swift
//  UTCS
//
//  Created by Taylor Schmidt on 4/6/16.
//  Copyright © 2016 UTCS. All rights reserved.
//

import Foundation
import UIKit

/////////////// Should these be mutable? ///////////////
protocol UTCSLabViewLayoutAttributes {
    var size: CGSize { get set }
    var center: CGPoint { get set }
    var indexPath: NSIndexPath { get set }
}