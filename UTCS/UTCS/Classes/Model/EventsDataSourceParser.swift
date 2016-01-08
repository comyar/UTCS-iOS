import SwiftyJSON

final class EventsDataSourceParser: DataSourceParser {

    func parseValues(values: JSON) -> Any! {
        var events = [Event]()
        for eventData in values.array! {
            if let event = Event(json:eventData) {
                events.append(event)
            }
        }
        return events
    }
}
