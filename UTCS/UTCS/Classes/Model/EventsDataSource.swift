// Events table view cell identifier.
let EventsTableViewCellIdentifier  = "UTCSEventTableViewCell"

final class EventsDataSource: ServiceDataSource, UITableViewDataSource {
    // TODO: Move into Event model
    enum EventType: String {
        case All = "all"
        case Careers = "careers"
        case Talks = "talks"
        case Orgs = "orgs"
    }
    var eventData: [UTCSEvent]? {
        return data as? [UTCSEvent]
    }
    override var router: Router {
        return Router.Events()
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
    func filterEventsWithType(type: EventType) -> ([NSIndexPath], [NSIndexPath]){
        //TODO: Reimplement filtering
        filteredEvents = eventData!
        return ([],[])
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventData?.count ?? 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let event = eventData![indexPath.row]
        let cell: NewsTableViewCell = tableView.dequeueReusableCellWithIdentifier(EventsTableViewCellIdentifier)! as! NewsTableViewCell
        cell.detailLabel.text = event.description
        cell.title.text = event.name
        return cell
    }

}