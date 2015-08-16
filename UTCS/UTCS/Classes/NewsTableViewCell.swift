import Foundation

// Name of the image to use for a table view cell's accessory view.
let cellAccessoryImageName = "rightArrow"

class NewsTableViewCell: BouncyTableViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var detailLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        accessoryView = {
            let image = UIImage(named: cellAccessoryImageName)?.imageWithRenderingMode(.AlwaysTemplate)
            let imageView = UIImageView(image: image)
            imageView.tintColor = UIColor(white: 1.0, alpha: 0.5)
            return imageView
        }()


    }
    override func awakeFromNib() {
        backgroundColor = UIColor.clearColor()
    }
}