
// Key associated with index paths added by a filter.
let UTCSEventsFilterAddIndex = 0

// Key associated with index paths added by a filter.
let UTCSEventsFilterRemoveIndex  = 1

// Key used to cache events.
let UTCSEventsDataSourceCacheKey = "UTCSEventsDataSourceCacheKey"

// Events table view cell identifier.
let UTCSEventsTableViewCellIdentifier  = "UTCSEventTableViewCell"

final class EventsDataSource: DataSource, UITableViewDataSource {
    // TODO: Move into Event model
    enum EventType: String {
        case All = "all"
        case Careers = "careers"
        case Talks = "talks"
        case Orgs = "orgs"
    }
    var eventData: [UTCSEvent]? {
        get{
            return data as? [UTCSEvent]
        }
    }
    override var router: Router {
        get {
            return Router.Events()
        }
    }
    var currentFilterType = EventType.All
    var filteredEvents = [UTCSEvent]()
    var typeColorMapping = [EventType.Careers: UIColor.utcsEventCareersColor(),
                                .Talks: UIColor.utcsEventTalkColor(),
                                .Orgs: UIColor.utcsEventStudentOrgsColor()]
    init(){
        super.init(service: .Events, parser: EventsDataSourceParser())
        minimumTimeBetweenUpdates = 3 * 60 * 60


    }
    func filterEventsWithType(type: EventType) -> [[NSIndexPath]]{
        return []
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventData?.count ?? 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}