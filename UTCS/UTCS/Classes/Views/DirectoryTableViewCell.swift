import Foundation
import UIKit

class DirectoryTableViewCell: BouncyTableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clearColor()
        textLabel?.textColor = UIColor.whiteColor()
        
        selectionStyle = .Default
        setSelectedBackgroundColor(UIColor.grayColor().colorWithAlphaComponent(0.5))
            
        detailTextLabel?.textColor = UIColor.lightGrayColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(person: DirectoryPerson) {
        let attributedName = NSMutableAttributedString(string: person.fullName)

        let firstNameLength = person.firstName.characters.count
        let firstNameRange = NSRange(location: 0, length: firstNameLength)
        let remainingRange = NSRange(location: firstNameLength + 1, length: person.fullName.characters.count - 1 - firstNameLength)

        let firstNameWeight = UIFont.systemFontOfSize(textLabel!.font.pointSize, weight: UIFontWeightBold)
        let remainingWeight = UIFont.systemFontOfSize(textLabel!.font.pointSize, weight: UIFontWeightLight)
        attributedName.addAttribute(NSFontAttributeName, value: firstNameWeight, range: firstNameRange)
        attributedName.addAttribute(NSFontAttributeName, value: remainingWeight, range: remainingRange)
        textLabel?.attributedText = attributedName
        detailTextLabel?.text = person.title
    }
}