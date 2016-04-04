import Foundation
import UIKit
import SwiftyJSON

class DirectoryPerson: NSObject, NSCoding, Binnable {
    var fullName: String!
    var firstName: String!
    var lastName: String!
    var office: String?
    let phoneNumber: String?
    var title: String?
    var imageURL: NSURL?

    init?(json: JSON) {
        guard let firstName = json["fname"].string,
            lastName = json["lname"].string,
            fullName = json["name"].string else {
                return nil
        }
        self.fullName = fullName
        self.firstName = firstName
        self.lastName = lastName

        office = json["office"].string
        phoneNumber = json["phone"].string
        title  = json["title"].string
        imageURL = json["image"].URL
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        guard let fullName = aDecoder.decodeObjectForKey("name") as? String,
            firstName = aDecoder.decodeObjectForKey("fname") as? String,
            lastName = aDecoder.decodeObjectForKey("lname") as? String else {
                return nil
        }
        self.fullName = fullName
        self.firstName = firstName
        self.lastName = lastName
        office = aDecoder.decodeObjectForKey("office") as? String
        phoneNumber = aDecoder.decodeObjectForKey("phone") as? String
        title = aDecoder.decodeObjectForKey("title") as? String
        imageURL = aDecoder.decodeObjectForKey("image") as? NSURL
        super.init()
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(fullName, forKey: "name")
        aCoder.encodeObject(firstName, forKey: "fname")
        aCoder.encodeObject(lastName, forKey: "lname")
        aCoder.encodeObject(office, forKey: "office")
        aCoder.encodeObject(phoneNumber, forKey: "phone")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(imageURL, forKey: "image")
    }

    func shouldBeSeparated(from: DirectoryPerson) -> Bool {
        let first = lastName as NSString
        let second = from.lastName as NSString
        return first.substringToIndex(1) != second.substringToIndex(1)
    }
}
