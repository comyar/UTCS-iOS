import Foundation
import UIKit

class SettingsTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        accessoryType = .None
        backgroundColor = UIColor.clearColor()
        textLabel?.textColor = UIColor.whiteColor()
        imageView?.tintColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}