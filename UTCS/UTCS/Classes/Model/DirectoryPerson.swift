@objc class DirectoryPerson: NSObject, NSCoding, Binnable {
    var fullName: String!
    var firstName: String!
    var lastName: String!
    var office: String?
    var phoneNumber: String?
    var type: String?
    var imageURL: NSURL?

    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fullName = aDecoder.decodeObjectForKey("name") as! String
        firstName = aDecoder.decodeObjectForKey("fName") as! String
        lastName = aDecoder.decodeObjectForKey("lName") as! String
        office = aDecoder.decodeObjectForKey("office") as? String
        phoneNumber = aDecoder.decodeObjectForKey("phone") as? String
        type = aDecoder.decodeObjectForKey("type") as? String
        imageURL = aDecoder.decodeObjectForKey("imageURL") as? NSURL
        super.init()
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(fullName, forKey: "name")
        aCoder.encodeObject(firstName, forKey: "fName")
        aCoder.encodeObject(lastName, forKey: "lName")
        aCoder.encodeObject(office, forKey: "office")
        aCoder.encodeObject(phoneNumber, forKey: "phone")
        aCoder.encodeObject(type, forKey: "type")
        aCoder.encodeObject(imageURL, forKey: "imageURL")
    }
    func shouldBeSeparated(from: DirectoryPerson) -> Bool {
        let first = lastName as NSString
        let second = from.lastName as NSString
        return first.substringToIndex(1) == second.substringToIndex(1)
    }
}
