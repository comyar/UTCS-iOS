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
    var type: Category?
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
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.id = id

        allDay = json["allday"].bool
        contactName = json["contactname"].string
        contactEmail = json["contactemail"].string
        food = json["food"].bool
        descriptionText = json["description"].string
        link = json["link"].URL
        if let typeString = json["type"].string {
            type = Category(rawValue: typeString)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init()
        guard let name = aDecoder.decodeObjectForKey("name") as? String,
               location = aDecoder.decodeObjectForKey("location") as? String,
               startDate = aDecoder.decodeObjectForKey("startdate") as? NSDate,
               endDate = aDecoder.decodeObjectForKey("enddate") as? NSDate,
               id = aDecoder.decodeObjectForKey("eventID") as? String else {
                return nil
        }
        self.name = name
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.id = id

        allDay = aDecoder.decodeBoolForKey("allDay")
        food = aDecoder.decodeBoolForKey("food")
        contactEmail = aDecoder.decodeObjectForKey("contactemail") as? String
        contactName = aDecoder.decodeObjectForKey("contactname") as? String
        descriptionText = aDecoder.decodeObjectForKey("description") as? String
        link = aDecoder.decodeObjectForKey("link") as? NSURL
        if let typeString = aDecoder.decodeObjectForKey("type") as? String {
            type = Category(rawValue: typeString)
        }

    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(location, forKey: "location")
        aCoder.encodeObject(startDate, forKey: "startdate")
        aCoder.encodeObject(endDate, forKey: "enddate")
        aCoder.encodeObject(id, forKey: "eventID")

        aCoder.encodeBool(allDay, forKey: "allday")
        aCoder.encodeBool(food, forKey: "food")
        aCoder.encodeObject(contactName, forKey: "contactname")
        aCoder.encodeObject(contactEmail, forKey: "contactemail")
        aCoder.encodeObject(descriptionText, forKey: "description")
        aCoder.encodeObject(link, forKey: "link")
        aCoder.encodeObject(type?.rawValue ?? nil, forKey: "type")
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