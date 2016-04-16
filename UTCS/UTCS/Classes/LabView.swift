import UIKit
import Foundation

protocol LabViewDataSource {
    func labView(labView: LabView, machineViewForIndexPath: NSIndexPath, name: String) -> LabMachineView
}

class LabView : UIView {
    var machineViews = [LabMachineView]()
    var layout: LabViewLayout
    var dataSource: LabViewDataSource?

    init(frame: CGRect, layout: LabViewLayout) {
        self.layout = layout
        super.init(frame: frame)
        prepareLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func invalidateLayout() {
        prepareLayout()
    }
    
    func prepareLayout() {
        layout.prepareLayoutForLabView(self)
        machineViews.forEach{$0.removeFromSuperview()}
        machineViews = []
        
        for i in 0..<layout.numberOfMachines {
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            let labMachineView = LabMachineView()
            labMachineView.tag = indexPath.row
            machineViews.append(labMachineView)
        }
    }
    
    func dequeueMachineViewForIndexPath(indexPath: NSIndexPath) -> LabMachineView {
        return machineViews[indexPath.row]
    }
    
    func reloadData() {
        let count = machineViews.count
        for i in 0..<count {
            let indexPath = NSIndexPath(forRow: i, inSection: 0)

            if let attributes = layout.layoutAttributesForIndexPath(indexPath),
                name = layout.labMachineNameForIndexPath(indexPath),
                machineView = dataSource?.labView(self, machineViewForIndexPath: indexPath, name: name){

                machineView.frame = CGRect(x: 0.0, y: 0.0, width: attributes.size.width, height: attributes.size.height)
                machineView.center = attributes.center
                machineView.tag = indexPath.row
                addSubview(machineView)
            }

        }
    }
    
}