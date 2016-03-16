import Foundation
import UIKit

class SettingsTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        accessoryType = .None
        backgroundColor = UIColor.clearColor()
        textLabel?.textColor = UIColor.whiteColor()
        imageView?.tintColor = UIColor.whiteColor()
        detailTextLabel?.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
        detailTextLabel?.numberOfLines = 0
    }
}