import Foundation
import UIKit

class ArticleViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    private var imageHeightConstraint: NSLayoutConstraint? = nil
    // Label used to display the title of a news story
    @IBOutlet weak var titleLabel: UILabel!

    // Label used to display the date of a news story
    @IBOutlet weak var dateLabel: UILabel!

    // Text view used to display the news story
    @IBOutlet weak var contentTextView: UITextView!

    static let defaultHeaderIdentifiers = ["gdc-speedway"]
    var activityItems = [String]()


    convenience init() {
        self.init(nibName: "ArticleView", bundle: nil)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        view.backgroundColor = UIColor.whiteColor()

        automaticallyAdjustsScrollViewInsets = true
        let button = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "share:")
        navigationItem.rightBarButtonItem = button

        contentTextView.scrollEnabled = false
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func configureImageHeightConstraint(image: UIImage) {
        if let currentConstraint = imageHeightConstraint {
            imageView.removeConstraint(currentConstraint)
        }
        let height = image.size.height
        let width = image.size.width

        let containerWidth = imageView.frame.width
        let widthRatio = containerWidth / width

        let fixedHeight = widthRatio * height

        let constraint = NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: fixedHeight)
        imageView.addConstraint(constraint)
        imageHeightConstraint = constraint
    }

    func share(sender: UIBarButtonItem) {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypeAssignToContact, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypeSaveToCameraRoll]
        presentViewController(activityViewController, animated: true, completion: nil)
    }
}