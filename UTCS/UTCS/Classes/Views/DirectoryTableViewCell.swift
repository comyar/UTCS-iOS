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

        let lastNameLength = person.lastName.characters.count
        let lastNameRange = NSRange(location: person.fullName.characters.count - lastNameLength, length: lastNameLength)
        let remainingRange = NSRange(location: 0, length: person.fullName.characters.count - lastNameLength)

        let firstNameWeight = UIFont.systemFontOfSize(textLabel!.font.pointSize, weight: UIFontWeightLight)
        let remainingWeight = UIFont.systemFontOfSize(textLabel!.font.pointSize, weight: UIFontWeightBold)
        attributedName.addAttribute(NSFontAttributeName, value: firstNameWeight, range: remainingRange)
        attributedName.addAttribute(NSFontAttributeName, value: remainingWeight, range: lastNameRange)
        textLabel?.attributedText = attributedName
        detailTextLabel?.text = person.title
    }
    
}
