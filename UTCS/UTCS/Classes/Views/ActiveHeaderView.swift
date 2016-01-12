import UIKit
import Foundation

class ActiveHeaderView: UIView {

    // Image view used to render the down arrow
    @IBOutlet var downArrowImageView: UIImageView!
    // Activity indicator used to indicate the items are updating
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    // Label used to display the time the items were updated
    @IBOutlet var updatedLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!

    //MARK: Constants
    // Duration of animations performed by this view
    let animationDuration = 0.3


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure() {
        downArrowImageView.tintColor = UIColor.whiteColor()
        downArrowImageView.alpha = 0.0
    }


    func startActiveAnimation() {
        activityIndicatorView.startAnimating()

        UIView.animateWithDuration(animationDuration) {
            self.updatedLabel.alpha = 0.0
            self.downArrowImageView.alpha = 0.0
            self.activityIndicatorView.alpha =  1.0
        }
    }

    func endActiveAnimation(success: Bool) {
        activityIndicatorView.stopAnimating()

        UIView.animateWithDuration(animationDuration) {
            self.updatedLabel.alpha = 0.45
            self.downArrowImageView.alpha   = success ? 0.45 : 0.0
            self.activityIndicatorView.alpha =  0.0
        }
    }
}
