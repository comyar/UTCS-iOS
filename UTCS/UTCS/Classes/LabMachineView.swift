import Foundation
import UIKit

class LabMachineView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderColor = UIColor(white: 0.0, alpha: 0.1).CGColor
        layer.borderWidth = 1.0
        backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        layer.masksToBounds = true
    }

    override func layoutSubviews() {
        layer.cornerRadius = bounds.width / 2.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}