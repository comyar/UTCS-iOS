import Foundation
import UIKit

class EventsDetailViewController: ArticleViewController {

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
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(event: Event) {
        guard event != self.event else {
            return
        }
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
            configureImageHeightConstraint(image)
        } else {

        }
        self.event = event
    }

    private func configureHeaderForNoImage() {
        dateLabel.textColor = UIColor.blackColor()
        titleLabel.textColor = UIColor.blackColor()
        
    }

    private func headerImageNameForEvent(event: Event) -> String? {
        if event.location.containsString("GDC") {
            let matches = EventsDetailViewController.headerImageMapping.keys.filter({ (key) -> Bool in
                return event.location.containsString(key)
            })
            if let match = matches.first {
                return EventsDetailViewController.headerImageMapping[match]
            }
        }
        return nil
    }
}
