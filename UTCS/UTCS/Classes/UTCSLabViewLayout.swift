//
//  UTCSLabViewLayout.swift
//  UTCS
//
//  Created by Taylor Schmidt on 4/6/16.
//  Copyright © 2016 UTCS. All rights reserved.
//


//  This file might need some work. I'm not sure if the types are
//  all okay or what we want error handling to look like

import Foundation
import UIKit

class UTCSLabViewLayout {
    var meta: NSDictionary // TODO: What are these types
    var values: NSDictionary
    var layoutAttributes: [String: UTCSLabViewLayoutAttributes] = [:]
    var indexPathLayoutAttributes: [UTCSLabViewLayoutAttributes] = []
    var numberOfLabMachines: Int
    
    init?(filename: String) {
        let p = NSBundle.mainBundle().pathForResource(filename, ofType: "plist")
        guard let path = p else {
            // some error code?
            return nil
        }
        
        let d = NSDictionary(contentsOfFile: path)
        guard let layoutDictionary = d else {
            // some error code?
            return nil
        }
        
        self.meta = layoutDictionary["meta"] as! NSDictionary
        self.values = layoutDictionary["values"] as! NSDictionary
        self.numberOfLabMachines = self.values.count
    }
    
    // not sure about this one. Will these types work out?
    func labMachineNameForIndexPath(indexPath: NSIndexPath) -> String? {
        let layoutAttribute = layoutAttributesForIndexPath(indexPath)
        for (key, _) in self.layoutAttributes {
            // Check this. I don't really know if this is correct
            guard let cur = self.layoutAttributes[key] else {
                // some error code?
                return nil
            }
            // This equality check was especially dubious. Is this supposed to check identity?
            if (layoutAttribute as! AnyObject).isEqual(cur) {
                return key
            }
        }
        return nil
    }
    
    func prepareLayoutForLabView(labView: UTCSLabView) {
        let _h = self.meta["maximumGridHeight"]?.floatValue
        let _w = self.meta["maximumGridWidth"]?.floatValue
        guard let maxGridHeight = _h, maxGridWidth = _w else {
            // some error code?
            return
        }
        let heightMultiplier = CGRectGetHeight(labView.bounds) / CGFloat(maxGridHeight)
        let widthMultiplier = CGRectGetWidth(labView.bounds) / CGFloat(maxGridWidth)
        
        let height = CGRectGetHeight(labView.bounds) / 28.25
        let width = height
        var index = 0
        var layoutAttributes: [String: UTCSLabViewLayoutAttributes] = [:]
        var indexPathLayoutAttributes: [UTCSLabViewLayoutAttributes] = []
        
        for (key, machineCoordinate) in self.values {
            let _x = machineCoordinate["x"]!!.floatValue
            let _y = machineCoordinate["y"]!!.floatValue
            guard let x = _x, let y = _y else {
                // some error code? 
                return
            }
            
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            let center = CGPointMake(CGFloat(x) * widthMultiplier, CGFloat(y) * heightMultiplier)
            let size = CGSizeMake(width, height)
            let attributes = UTCSLabViewLayoutAttributes(size: size, center: center, indexPath: indexPath)
            
            layoutAttributes[key as! String] = attributes
            indexPathLayoutAttributes.append(attributes)
            index += 1
        }
        self.layoutAttributes = layoutAttributes
        self.indexPathLayoutAttributes = indexPathLayoutAttributes
    }
    
    // Should this return type be optional?
    func layoutAttributesForIndexPath(indexPath: NSIndexPath) -> UTCSLabViewLayoutAttributes? {
        return self.indexPathLayoutAttributes[indexPath.row] 
    }
    
    // Should this return type be optional?
    func layoutAttributesForLabMachineName(labMachineName: String) -> UTCSLabViewLayoutAttributes? {
        return self.layoutAttributes[labMachineName]
    }
}
