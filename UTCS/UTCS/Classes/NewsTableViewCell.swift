import Foundation

class NewsTableViewCell: BouncyTableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var detailLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        accessoryType = .DisclosureIndicator
        backgroundColor = .clearColor()
    }

}
