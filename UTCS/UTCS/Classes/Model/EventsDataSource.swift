
let EventsTableViewCellIdentifier = "UTCSEventTableViewCell"

final class EventsDataSource: ServiceDataSource, UITableViewDataSource {

    typealias EventCategoryFilterResult = (matching: [NSIndexPath], nonmatching: [NSIndexPath])
    
    override var data: AnyObject! {
        didSet(oldValue) {
            filteredEvents = eventData
        }
    }
    var eventData: [Event]? {
        return data as? [Event]
    }
    override var router: Router {
        return Router.Events()
    }
    var currentFilterType = Event.Category.All
    var filteredEvents: [Event]?
    static let typeColorMapping = [Event.Category.Careers: UIColor.utcsEventCareersColor(),
                                .Talks: UIColor.utcsEventTalkColor(),
                                .Orgs: UIColor.utcsEventStudentOrgsColor()]

    // MARK:- Initialization
    init() {
        super.init(service: .Events, parser: EventsDataSourceParser())
    }

    func filterEventsByCategory(category: Event.Category) -> EventCategoryFilterResult {
        currentFilterType = category
        
        guard let events = eventData else {
            return ([], [])
        }

        let matches = events.map { event in
            return event.category == category
        }
        let intToIndexPath = { int in
            return NSIndexPath(forRow: int, inSection: 0)
        }
        
        let range = 0..<events.count
        let matching = range.filter({ matches[$0] }).map(intToIndexPath)
        let nonmatching = range.filter({ !matches[$0] }).map(intToIndexPath)
        
        filteredEvents = matching.map { events[$0.row] }
    
        return (matching, nonmatching)
    }

    // MARK:- UITableViewDataSource

    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEvents?.count ?? 0
    }

    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let dequeued = tableView.dequeueReusableCellWithIdentifier(EventsTableViewCellIdentifier),
            let cell = dequeued as? NewsTableViewCell else {
                return UITableViewCell()
        }
        let event = filteredEvents![indexPath.row]
        cell.detailLabel.text = event.dateString
        cell.title.text = event.name

        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }

}
