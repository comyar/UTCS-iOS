// Events table view cell identifier.
let EventsTableViewCellIdentifier  = "UTCSEventTableViewCell"

final class EventsDataSource: ServiceDataSource, UITableViewDataSource {

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
    /**
     <#Description#>

     - parameter type: <#type description#>

     - returns: tuple with indexes to remove and indexes to add
     */
    func filterEventsWithType(type: Event.Category) -> ([NSIndexPath], [NSIndexPath]) {
        guard let allEvents = eventData,
               var filtered = filteredEvents else {
            return ([], [])
        }
        var newFiltered = [Event]()
        var toAdd = [Int]()
        var toRemove = [Int]()
        if type != .All {
            for i in 0..<filtered.count {
                let event = filtered[i]
                if event.type != type {
                    toRemove.append(i)
                }
            }
        }
        var index = 0
        for event in allEvents {
            if event.type == type {
                toAdd.append(index)
                index += 1
                newFiltered.append(event)
            }
        }

        filteredEvents = newFiltered
        let mapping = { (row) -> NSIndexPath in
                return NSIndexPath(forRow: row, inSection: 0)
        }

        let added = toAdd.map(mapping)
        let removed = toRemove.map(mapping)
        return (added, removed)
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
        cell.detailLabel.text = event.description
        cell.title.text = event.name

        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }

}
