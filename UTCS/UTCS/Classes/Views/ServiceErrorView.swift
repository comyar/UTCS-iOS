import UIKit
import Foundation
class ServiceErrorView: UIView {
    @IBOutlet var errorLabel: UILabel!

    class func loadFromNib() -> ServiceErrorView {
        return NSBundle.mainBundle().loadNibNamed("ServiceErrorView", owner: self, options: nil)[0] as! ServiceErrorView
    }
}
