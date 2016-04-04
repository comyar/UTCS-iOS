
import Foundation
import SwiftyJSON

class Event: NSObject, NSCoding {
    
    enum Category: String {
        case All = "all"
        case Careers = "careers"
        case Talks = "talks"
        case Orgs = "orgs"
    }
    
    let id: String
    let name: String
    let descriptionText: String
    var attributedDescription: NSAttributedString {
        return NSAttributedString(string: descriptionText)
    }
    let startDate: NSDate
    let allDay: Bool
    let link: NSURL
    let food: Bool
    
    // MARK: - These properties tend to be nil (Pretty much always).
    let category: Category?
    let location: String?
    let endDate: NSDate?
    let contactName: String?
    let contactEmail: String?
    
    var dateString: String {
        // All day events and events without end dates
        guard !allDay, let endDate = endDate else {
            return NSDateFormatter.localizedStringFromDate(startDate, dateStyle: .LongStyle, timeStyle: .NoStyle)
        }
        // Get current calendar
        let calendar = NSCalendar.currentCalendar()
        // Get length of event in days
        let eventLength = calendar.components(.Day, fromDate: startDate, toDate: endDate, options: .WrapComponents)
        // Calculate string for start and end date
        let startDateString = NSDateFormatter.localizedStringFromDate(startDate, dateStyle: .LongStyle, timeStyle: .ShortStyle)
        let endDateString: String
        if eventLength.day > 0 {
            endDateString = NSDateFormatter.localizedStringFromDate(endDate, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        } else {
            endDateString = NSDateFormatter.localizedStringFromDate(endDate, dateStyle: .NoStyle, timeStyle: .ShortStyle)
        }
        return startDateString + " - " + endDateString
    }

    init?(json: JSON) {
        guard let id = json["eventID"].string,
            name = json["name"].string,
            descriptionText = json["description"].string,
            startDateString = json["startdate"].string,
            allDay = json["allday"].bool,
            link = json["link"].URL,
            food = json["food"].bool else { return nil }
        
        self.id = id
        self.name = name
        self.descriptionText = descriptionText
        self.startDate = serviceDateFormatter.dateFromString(startDateString)!
        self.allDay = allDay
        self.link = link
        self.food = food
        
        if let category = json["category"].string {
            self.category = Category(rawValue: category)
        } else {
            self.category = nil
        }
        self.location = json["location"].string
        if let endDateString = json["enddate"].string {
            self.endDate = serviceDateFormatter.dateFromString(endDateString)
        } else {
            self.endDate = nil
        }
        self.contactName = json["contactname"].string
        self.contactEmail = json["contactemail"].string
        super.init()
    }
    
    // MARK: - NSCoding
    
    required init?(coder: NSCoder) {
        guard let id = coder.decodeObjectForKey("eventID") as? String,
            name = coder.decodeObjectForKey("name") as? String,
            descriptionText = coder.decodeObjectForKey("description") as? String,
            startDate = coder.decodeObjectForKey("startdate") as? NSDate,
            link = coder.decodeObjectForKey("url") as? NSURL else { return nil }
        
        self.id = id
        self.name = name
        self.descriptionText = descriptionText
        self.startDate = startDate
        self.link = link
        self.allDay = coder.decodeBoolForKey("allday")
        self.food = coder.decodeBoolForKey("food")
        
        if let category = coder.decodeObjectForKey("category") as? String {
            self.category = Category(rawValue: category)
        } else {
            self.category = nil
        }
        self.location = coder.decodeObjectForKey("location") as? String
        self.endDate = coder.decodeObjectForKey("enddate") as? NSDate
        self.contactEmail = coder.decodeObjectForKey("contactemail") as? String
        self.contactName = coder.decodeObjectForKey("contactname") as? String
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(id, forKey: "eventID")
        coder.encodeObject(name, forKey: "name")
        coder.encodeObject(descriptionText, forKey: "description")
        coder.encodeObject(startDate, forKey: "startdate")
        coder.encodeBool(allDay, forKey: "allday")
        coder.encodeBool(food, forKey: "food")
        
        coder.encodeObject(category?.rawValue, forKey: "category")
        coder.encodeObject(location, forKey: "location")
        coder.encodeObject(endDate, forKey: "enddate")
        coder.encodeObject(contactName, forKey: "contactname")
        coder.encodeObject(contactEmail, forKey: "contactemail")
        coder.encodeObject(link, forKey: "link")
    }
    
}
