import Foundation
import UIKit

class EventViewController: ArticleViewController {
    @IBOutlet weak var headerContainer: UIView!
    private var noImageConstraint: NSLayoutConstraint?
    private static let headerImageMapping = ["1.304":"gdc-1,304",
    "1.406":"gdc-1,406",
    "2.410":"gdc-2,410",
    "5.302":"gdc-5,302",
    "5.304":"gdc-5,304",
    "6.102":"gdc-6,102",
    "6.302":"gdc-6,302",
    "auditorium":"gdc-auditorium",
    "atrium":"gdc-atrium"]

    private var event: Event!

    init() {
        super.init(nibName: "EventView", bundle: nil)
        automaticallyAdjustsScrollViewInsets = true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(event: Event) {
        guard event != self.event else {
            return
        }
        removeNoImageConstraint()
        scrollView.contentOffset = CGPointZero

        activityItems.append(event.name)
        activityItems.append(event.location)

        if let dateText = dateLabel.text {
            activityItems.append(dateText)
        }

        if let link = event.link {
            activityItems.append(link.absoluteString)
        }

        titleLabel.text = event.name
        contentTextView.text = event.descriptionText
        dateLabel.text = event.dateString() + "\n" + event.location
        if let headerImageName = headerImageNameForEvent(event),
           let image = UIImage(named: headerImageName){
            imageView.image = image
            dateLabel.textColor = UIColor.whiteColor()
            titleLabel.textColor = UIColor.whiteColor()
            configureImageHeightConstraint(image)
        } else {
            configureHeaderForNoImage()
        }
        self.event = event
    }

    private func configureHeaderForNoImage() {
        dateLabel.textColor = UIColor.blackColor()
        titleLabel.textColor = UIColor.blackColor()
        imageView.backgroundColor = UIColor.clearColor()
        imageView.image = nil
        if let constraint = imageHeightConstraint {
            imageView.removeConstraint(constraint)
        }
        let constraint = NSLayoutConstraint(item: titlingContainer, attribute: .Height, relatedBy: .Equal, toItem: headerContainer, attribute: .Height, multiplier: 1.0, constant: 0.0)
        headerContainer.addConstraint(constraint)
        noImageConstraint = constraint
    }

    private func removeNoImageConstraint() {
        if let constraint = noImageConstraint {
            headerContainer.removeConstraint(constraint)
        }
    }

    private func headerImageNameForEvent(event: Event) -> String? {
        let lowerLocation = event.location.lowercaseString
        if lowerLocation.containsString("gdc") {
            let matches = EventViewController.headerImageMapping.keys.filter({ (key) -> Bool in
                return lowerLocation.containsString(key)
            })
            if let match = matches.first {
                return EventViewController.headerImageMapping[match]
            } else {
                // Default image for GDC events
                return "gdc-speedway"
            }
        }
        return nil
    }
}
