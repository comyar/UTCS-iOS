import SwiftyJSON

struct QuotaData {
    var limit: Int!
    var usage: Double!
    var user: String!
    var name: String!
}

extension QuotaData {
    init(json: JSON) {
        limit = json["limit"].int
        usage = json["usage"].double
        user = json["user"].string
        name = json["name"].string
    }
}
