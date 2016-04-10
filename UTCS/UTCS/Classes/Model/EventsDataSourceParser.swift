import SwiftyJSON

final class EventsDataSourceParser: DataSourceParser {

    func parseValues(values: JSON) -> AnyObject? {
        let parsed: [Event]? = parseValues(values)
        return parsed
    }

    func parseValues(values: JSON) -> [Event]? {
        if let jsonArray = values.array {
            return jsonArray.map{Event(json: $0)}.flatMap{$0}
        }
        return nil
    }
}
