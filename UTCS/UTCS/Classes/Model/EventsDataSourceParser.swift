import SwiftyJSON

final class EventsDataSourceParser: DataSourceParser {
    var parsedEvents: [UTCSEvent] {
        return parsed as! [UTCSEvent]
    }
    override func parseValues(values: JSON) {
        var events = [UTCSEvent]()
        for eventData in values.array! {
            let event = UTCSEvent()
            event.name = eventData["name"].string
            event.contactName = eventData["contactname"].string
            event.contactEmail = eventData["contactemail"].string
            event.allDay = eventData["allday"].bool!
            event.location = eventData["location"].string
            event.eventDescription = eventData["description"].string
            event.startDate = DataSourceParser.dateFormatter.dateFromString(eventData["startdate"].string!)
            if let enddate = eventData["enddate"].string {
                event.endDate = DataSourceParser.dateFormatter.dateFromString(enddate)
            }
                events.append(event)
        }
        parsed = events
    }
}