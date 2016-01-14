import SwiftyJSON

class QuotaData: NSObject, NSCoding {
    var limit: Int!
    var usage: Double!
    var user: String!
    var name: String!

    init?(json: JSON) {
        super.init()
        guard let limit = json["limit"].int,
            usage = json["usage"].double,
            user = json["user"].string,
            name = json["name"].string else {
            return nil
        }
        self.limit = limit
        self.usage = usage
        self.user = user
        self.name = name

    }

    required init?(coder aDecoder: NSCoder) {
        super.init()
        guard let user = aDecoder.decodeObjectForKey("user") as? String,
            name = aDecoder.decodeObjectForKey("name") as? String,
            limit = aDecoder.decodeObjectForKey("limit") as? Int,
            usage = aDecoder.decodeObjectForKey("usage") as? Double else {
                return nil
        }
        self.user = user
        self.name = name
        self.limit = limit
        self.usage = usage
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(limit, forKey: "limit")
        aCoder.encodeObject(usage, forKey: "usage")
        aCoder.encodeObject(user, forKey: "user")
        aCoder.encodeObject(name, forKey: "name")
    }

}
