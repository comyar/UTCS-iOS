import Shimmer
//MARK: Constants
// Duration of animations performed by this view
let animationDuration = 0.3

class ActiveHeaderView: UIView {

    // Shimmering view used to indicate loading of news articles
    @IBOutlet var shimmeringView: FBShimmeringView!
    // Image view used to render the down arrow
    @IBOutlet var downArrowImageView: UIImageView!
    // Activity indicator used to indicate the news stories are updating
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    // Label used to display the time the news stories were updated
    @IBOutlet var updatedLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var sectionHeadLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        downArrowImageView.tintColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func showActiveAnimation(show: Bool) {
        downArrowImageView.tintColor = UIColor.whiteColor()
        if show {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }

        self.shimmeringView.shimmering = show
        UIView.animateWithDuration(animationDuration) {
            self.updatedLabel.alpha = show ? 0.0 : 0.45
            self.downArrowImageView.alpha   = show ? 0.0 : 0.45
            self.activityIndicatorView.alpha = show ? 1.0 : 0.0
        }
    }
}
