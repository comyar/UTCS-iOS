//
//  UTCSLabView.swift
//  UTCS
//
//  Created by Taylor Schmidt on 4/8/16.
//  Copyright © 2016 UTCS. All rights reserved.
//
import UIKit

import Foundation

protocol UTCSLabViewDataSource {
    func labView(labView: UTCSLabView, machineViewForIndexPath: NSIndexPath, name: String) -> UTCSLabMachineView
}

class UTCSLabView : UIView {
    var machineViews = [UTCSLabMachineView]()
    var layout: UTCSLabViewLayout
    var dataSource: UTCSLabViewDataSource?
    init(frame: CGRect, layout: UTCSLabViewLayout) {
        self.layout = layout
        super.init(frame: frame)
        self.prepareLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func invalidateLayout() {
        self.prepareLayout()
    }
    
    func prepareLayout() {
        self.layout.prepareLayoutForLabView(self)
        for machineView in self.machineViews { machineView.removeFromSuperview() }
        self.machineViews = []
        
        for i in 0..<self.layout.numberOfLabMachines {
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            let labMachineView = UTCSLabMachineView()
            labMachineView.tag = indexPath.row
            self.machineViews.append(labMachineView)
        }
    }
    
    func dequeueMachineViewForIndexPath(indexPath: NSIndexPath) -> UTCSLabMachineView {
        return self.machineViews[indexPath.row]
    }
    
    func reloadData() {
        let count = self.machineViews.count
        for i in 0..<count {
            let indexPath = NSIndexPath(forItem: i, inSection: 0) // should this be forRow?
            let machineName = self.layout.labMachineNameForIndexPath(indexPath)
            guard let layoutAttributes = self.layout.layoutAttributesForIndexPath(indexPath) else {
                // some error code?
                return
            }
            let machineView = self.dataSource!.labView(self, machineViewForIndexPath: indexPath, name: machineName!)
            machineView.frame = CGRectMake(0.0, 0.0, layoutAttributes.size.width, layoutAttributes.size.height)
            machineView.center = layoutAttributes.center
            machineView.tag = indexPath.row
            self.addSubview(machineView)
        }
    }
    
}