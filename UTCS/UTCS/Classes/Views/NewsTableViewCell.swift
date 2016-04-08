import UIKit

class NewsTableViewCell: ClearTableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var detailLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        accessoryType = .DisclosureIndicator
        selectionStyle = .Default
        
        setSelectedBackgroundColor(UIColor.grayColor().colorWithAlphaComponent(0.5))
    }

}
