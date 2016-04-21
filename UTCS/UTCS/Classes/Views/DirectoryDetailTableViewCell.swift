import Foundation

class DirectoryDetailTableViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        textLabel?.textColor = UIColor(white: 1.0, alpha: 0.8)
        textLabel?.numberOfLines = 0
        textLabel?.lineBreakMode = .ByWordWrapping
        detailTextLabel?.textColor = UIColor(white: 1.0, alpha: 0.5)
        imageView?.contentMode = .ScaleAspectFill
        imageView?.autoresizingMask = .None
        backgroundColor = UIColor.clearColor()
        selectionStyle = .None
        textLabel?.textAlignment = .Left

        let callButton = UIButton.bouncyButton()

        callButton.frame = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 28.0)
        callButton.setTitle("Call", forState: .Normal)
        callButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        callButton.tintColor = UIColor.whiteColor()
        callButton.layer.masksToBounds = true
        callButton.layer.cornerRadius = 4.0
        callButton.layer.borderWidth = 1.0
        callButton.layer.borderColor = UIColor.whiteColor().CGColor
        callButton.tag = Int.min
        accessoryView = callButton
        accessoryView?.hidden = true

    }
}