import UIKit

class ClearTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = .clearColor()
        selectionStyle = .Default
        setSelectedBackgroundColor(.utcsCellHighlight())
        
        textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        textLabel?.textColor = .whiteColor()
        
        detailTextLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        detailTextLabel?.textColor = .grayColor()
    }
    
}
