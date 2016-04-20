import UIKit

@IBDesignable class NewsTableViewCell: ClearTableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var stripe: UIView!
    @IBInspectable var stripeColor: UIColor = .clearColor() {
        didSet(oldValue) {
            stripe.backgroundColor = stripeColor
            setNeedsDisplay()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        accessoryType = .DisclosureIndicator
    }

    override func prepareForReuse() {
        stripe.backgroundColor = .clearColor()
        backgroundView = nil
    }

}