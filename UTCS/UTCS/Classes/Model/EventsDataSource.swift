import UIKit
import Foundation

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
    let intToIndexPath = { int in
        return NSIndexPath(forRow: int, inSection: 0)
    }

    // MARK:- Initialization
    init() {
        super.init(service: .Events, parser: EventsDataSourceParser())
    }


    func filterEventsByCategory(category: Event.Category) -> EventCategoryFilterResult {
        currentFilterType = category

        // Events that are currently on screen
        guard let displaying = filteredEvents ?? eventData,
                allEvents = eventData else {
            return ([], [])
        }

        let displayingSet = Set(displaying)
        let visibleMatches = displaying.map { $0.category ~~ category}

        // All currently visible events that will be hidden. They have the wrong category
        let toRemovePaths: [NSIndexPath] =  {
            let range = 0..<displaying.count
            return range.filter{ !visibleMatches[$0] }.map(intToIndexPath)
        }()
        // Non visible elements that need to be added
        let toAdd = allEvents.filter{!displayingSet.contains($0) && $0.category ~~ category}

        let finalVisible: [Event] = {
            // All currently visible events that will remain visible. They have the correct category
            var toKeepEvents = displaying.filter{$0.category ~~ category}
            toKeepEvents.appendContentsOf(toAdd)
            // Sort toKeep. It now is the list of events that will ultimately be displayed
            toKeepEvents.sortInPlace{$0.startDate < $1.startDate}
            return toKeepEvents
        }()

        filteredEvents = finalVisible

        let toAddPaths: [NSIndexPath] = {
            let nRange = 0..<finalVisible.count
            return nRange.filter{!displayingSet.contains(finalVisible[$0])}.map(self.intToIndexPath)
        }()

        return (toAddPaths, toRemovePaths)
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
        cell.title.text = event.name.sanitizeHTML()
        if let category = event.category {
            cell.stripeColor = category.color
        }
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }

}