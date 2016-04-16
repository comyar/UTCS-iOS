import Foundation
import UIKit

class LabViewLayout {
    private let coordinates: [String: CGPoint]
    private let maxGridWidth: Int
    private let maxGridHeight: Int
    var numberOfMachines: Int {
        return coordinates.count
    }

    private var layoutAttributes: [String: MachineLayoutAttributes]?
    private var layoutAttributesByPath: [MachineLayoutAttributes]?

    struct MachineLayoutAttributes {
        let name: String
        let size: CGSize
        let center: CGPoint
        let indexPath: NSIndexPath
    }
    
    init?(filename: String) {
        guard let path = NSBundle.mainBundle().pathForResource(filename, ofType: "plist"),
            dictionary = NSDictionary(contentsOfFile: path),
        meta = dictionary["meta"] as? NSDictionary,
        values = dictionary["values"] as? Dictionary<String, NSDictionary> else {
            return nil
        }

        // Parse meta
        guard let h = meta["maximumGridHeight"]?.integerValue,
            w = meta["maximumGridWidth"]?.integerValue else {
                return nil
        }
        let pairs: [(String, CGPoint)?] = values.map{ name, coordinate in
            guard let x = coordinate["x"]?.integerValue,
                y = coordinate["y"]?.integerValue else {
                    return nil
            }
            return (name, CGPoint(x: x, y: y))
        }

        var dictCoordinates = [String: CGPoint]()
        for pair in pairs where pair != nil {
            dictCoordinates[pair!.0] = pair!.1
        }

        self.maxGridWidth = w
        self.maxGridHeight = h
        self.coordinates = dictCoordinates
    }

    func prepareLayoutForLabView(labView: LabView) {
        let heightMultiplier = labView.bounds.height / CGFloat(maxGridHeight)
        let widthMultiplier = labView.bounds.height / CGFloat(maxGridWidth)
        
        let height = labView.bounds.height / 28.25
        let width = height
        var index = 0
        var layoutAttributes = [String: MachineLayoutAttributes]()
        for (name, coordinate) in coordinates {

            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            let center = CGPoint(x: coordinate.x * widthMultiplier, y: coordinate.y * heightMultiplier)
            let size = CGSize(width: width, height: height)
            let attributes = MachineLayoutAttributes(name: name, size: size, center: center, indexPath: indexPath)

            layoutAttributes[name] = attributes
            index += 1
        }
        self.layoutAttributes = layoutAttributes
        layoutAttributesByPath = layoutAttributes.values.map{$0}
    }

    func labMachineNameForIndexPath(indexPath: NSIndexPath) -> String? {
        if 0..<(layoutAttributes?.count ?? 0) ~= indexPath.row {
            return layoutAttributesByPath?[indexPath.row].name
        }
        return nil
    }

    // Should this return type be optional?
    func layoutAttributesForIndexPath(indexPath: NSIndexPath) -> MachineLayoutAttributes? {
        if 0..<(layoutAttributes?.count ?? 0) ~= indexPath.row {
            return layoutAttributesByPath?[indexPath.row]
        }
        return nil
    }
    
    // Should this return type be optional?
    func layoutAttributesForLabMachineName(labMachineName: String) -> MachineLayoutAttributes? {
        return layoutAttributes?[labMachineName]
    }
}
