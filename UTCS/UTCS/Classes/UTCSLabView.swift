//
//  UTCSLabView.swift
//  UTCS
//
//  Created by Taylor Schmidt on 4/8/16.
//  Copyright © 2016 UTCS. All rights reserved.
//
import UIKit

import Foundation

class UTCSLabView {
    var machineViews: [UTCSLabMachineView]
    var layout: UTCSLabViewLayout
    var dataSource: UTCSLabViewDataSource
    init(frame: CGRect, layout: UTCSLabViewLayout) {
        super.init(frame: frame)
        self.layout = layout
        self.prepareLayout()
    }
    
    func invalidateLayout() {
        self.prepareLayout
    }
    
    func prepareLayout() {
        self.layout.prepareLayoutForLabView(self)
        for machineView in self.machineViews { machineView.removeFromSuperview() }
        self.machineViews = nil
        
        var machineViews: [UTCSLabMachineView] = []
        for i in 0..<self.layout.numberOfLabMachines {
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            let labMachineView = UTCSLabMachineView()
            labMachineView.tag = indexPath.row
            machineViews.append(labMachineView)
        }
        self.machineViews = machineViews
    }
    
    func dequeueMachineViewForIndexPath(indexPath: NSIndexPath) -> UTCSLabMachineView {
        return self.machineViews[indexPath.row]
    }
    
    func reloadData() {
        let count = self.machineViews.count
        for i in 0..<count {
            let indexPath = NSIndexPath(forItem: i, inSection: 0) // should this be forRow?
            let machineName = self.layout.labMachineNameForIndexPath(indexPath)
            let layoutAttributes = self.layout.layoutAttributesForIndexPath(indexPath)
            let machineView = self.dataSource(labView: self, machineViewForIndexPath: indexPath, name: machineName)
            machineView.frame = CGRectMake(0.0, 0.0, layoutAttributes.size.width, layoutAttributes.size.height)
            machineView.center = layoutAttributes.center
            machineView.tag = indexPath.row
            self.addSubview(machineView)
        }
    }
    
}