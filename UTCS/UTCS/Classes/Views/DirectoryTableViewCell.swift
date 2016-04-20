import UIKit

class DirectoryTableViewCell: ClearTableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func commonInit() {
        super.commonInit()
        
        detailTextLabel?.textColor = .lightGrayColor()
    }

    func configure(person: DirectoryPerson) {
        let attributedName = NSMutableAttributedString(string: person.fullName)

        let firstNameLength = person.firstName.characters.count
        let firstNameRange = NSRange(location: 0, length: firstNameLength)
        let remainingRange = NSRange(location: firstNameLength + 1, length: person.fullName.characters.count - 1 - firstNameLength)

        let firstNameWeight = UIFont.systemFontOfSize(textLabel!.font.pointSize, weight: UIFontWeightLight)
        let remainingWeight = UIFont.systemFontOfSize(textLabel!.font.pointSize, weight: UIFontWeightBold)
        attributedName.addAttribute(NSFontAttributeName, value: firstNameWeight, range: firstNameRange)
        attributedName.addAttribute(NSFontAttributeName, value: remainingWeight, range: remainingRange)
        textLabel?.attributedText = attributedName
        detailTextLabel?.text = person.title
    }
    
}
