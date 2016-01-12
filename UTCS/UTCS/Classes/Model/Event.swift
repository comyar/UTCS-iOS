import Foundation
import SwiftyJSON

class Event: NSObject, NSCoding {
    enum Category: String {
        case All = "all"
        case Careers = "careers"
        case Talks = "talks"
        case Orgs = "orgs"
    }

    var name: String!
    var contactName: String?
    var contactEmail: String?
    var location: String!
    var descriptionText: String? {
        didSet(oldValue) {
            updateAttributedDescription()
        }
    }
    var attributedDescription: NSAttributedString?
    var type: Category!
    var startDate: NSDate!
    var endDate: NSDate!
    var food: Bool!
    var id: String!
    var allDay: Bool!
    var link: NSURL?

    private static let startDateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM d, h:mm a";
        return formatter
    }()

    init?(json: JSON) {
        super.init()
        guard let name = json["name"].string,
            let location = json["location"].string,
            let startDateString = json["startdate"].string,
            let startDate = serviceDateFormatter.dateFromString(startDateString),
            let endDateString = json["enddate"].string,
            let endDate = serviceDateFormatter.dateFromString(endDateString),
            let id = json["eventID"].string else {
                return nil
        }
        self.name = name
        contactName = json["contactname"].string
        contactEmail = json["contactemail"].string
        allDay = json["allday"].bool!
        self.location = location
        descriptionText = json["description"].string
        self.startDate = startDate
        self.endDate = endDate
        self.id = id

    }

    required init?(coder aDecoder: NSCoder) {
        super.init()
        guard let name = aDecoder.decodeObjectForKey("name") as? String,
               let location = aDecoder.decodeObjectForKey("location") as? String,
               let startDate = aDecoder.decodeObjectForKey("startDate") as? NSDate,
               let endDate = aDecoder.decodeObjectForKey("endDate") as? NSDate,
               let id = aDecoder.decodeObjectForKey("id") as? String else {
                return nil
        }
        self.name = name
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.id = id
        self.allDay = aDecoder.decodeBoolForKey("food")

        contactEmail = aDecoder.decodeObjectForKey("contactEmail") as? String
        contactName = aDecoder.decodeObjectForKey("contactName") as? String
        food = aDecoder.decodeBoolForKey("food")
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeBool(allDay, forKey: "allDay")
        aCoder.encodeBool(food, forKey: "food")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(contactName, forKey: "contactName")
        aCoder.encodeObject(location, forKey: "location")
        aCoder.encodeObject(descriptionText, forKey: "descriptionText")
        aCoder.encodeObject(attributedDescription, forKey: "attributedDescription")

    }

    private func updateAttributedDescription() {
        guard let text = descriptionText else {
            return
        }
        attributedDescription = NSAttributedString(string: text)
    }

    func dateString() -> String {
        if allDay == true {
            let dateString = NSDateFormatter.localizedStringFromDate(startDate,
                dateStyle: .LongStyle, timeStyle: .NoStyle)
            return dateString + " – All Day"
        }
        let currentCalendar = NSCalendar.currentCalendar()

        // Find difference in days between start date and end date
        let eventLength = currentCalendar.components(.Day, fromDate: startDate, toDate: endDate, options: .WrapComponents)

        // Default to using the endDateString for a same day event
        let startDateString = Event.startDateFormatter.stringFromDate(startDate)
        var endDateString = NSDateFormatter.localizedStringFromDate(endDate,
            dateStyle: .NoStyle, timeStyle: .ShortStyle)

        // If the event is over multiple days, update the endDateString
        if eventLength.day > 0 {
            endDateString = NSDateFormatter.localizedStringFromDate(endDate,
                dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        }

        // Combine the date strings and create attributed string

        return startDateString + " - " + endDateString
    }
    override func isEqual(object: AnyObject?) -> Bool {
        if let otherEvent = object as? Event {
            return otherEvent.id == id
        }
        return false
    }
}