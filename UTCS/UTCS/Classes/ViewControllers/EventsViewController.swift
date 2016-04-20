import UIKit
import Foundation

final class EventsViewController: HeaderTableViewController {

    var eventsDataSource: EventsDataSource? {
        return dataSource as? EventsDataSource
    }
    var filterSegmentedControl: UISegmentedControl!
    var segments = [Event.Category.All, .Orgs, .Talks, .Careers]
    var filterButtonImageView: UIImageView!
    let eventDetailViewController = EventViewController()

    init() {
        super.init(style: .Plain)
        dataSource = EventsDataSource()

        tableView.dataSource = eventsDataSource
        tableView.estimatedRowHeight = 48
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: EventsTableViewCellIdentifier)
        backgroundImageName = "Events"
        title = "Events"

        activeHeaderView.subtitleLabel.text = NewsViewController.headerSubtitleText
        update()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = menuButton
    }

    func didChangeValueForControl(control: UIControl) {
        if control == filterSegmentedControl {
            let index = filterSegmentedControl.selectedSegmentIndex
            let filterType = segments[index]
            let filterColor = filterType.color
            filterEventsWithType(filterType)
            filterSegmentedControl.tintColor = filterColor
        }
    }

    func filterEventsWithType(type: Event.Category) {
        let (addIndexPaths, removeIndexPaths) = eventsDataSource!.filterEventsByCategory(type)
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths(removeIndexPaths, withRowAnimation: .Middle)
        tableView.insertRowsAtIndexPaths(addIndexPaths, withRowAnimation: .Middle)
        if eventsDataSource?.filteredEvents?.count == 0 {
            let path = NSIndexPath(forRow: 0, inSection: 0)
            tableView.insertRowsAtIndexPaths([path], withRowAnimation: .Middle)
        }
        tableView.endUpdates()

    }

    func update() {
        // Can only update if we have a data source
        guard let source = eventsDataSource else {
            return
        }
        activeHeaderView.startActiveAnimation()
        source.updateWithArgument(nil) { result in
            self.activeHeaderView.endActiveAnimation(true)
            if self.eventsDataSource?.shouldDisplayTable() ?? false {
                self.lastUpdated = self.dataSource?.updated

            } else {
                if result.successful {
                    self.activeHeaderView.updatedLabel.text = "No events available"
                } else {
                    self.activeHeaderView.updatedLabel.text = "Please check your network connection."
                }
            }
            self.tableView.reloadData()
        }
    }
}


// MARK:- UITableViewDelegate
extension EventsViewController {

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 && eventsDataSource?.shouldDisplayTable() ?? false else {
            return nil
        }
        if filterSegmentedControl == nil {

            filterSegmentedControl = {
                let segmentNames = segments.map{$0.rawValue}
                let segmentedControl = UISegmentedControl(items: segmentNames)
                segmentedControl.backgroundColor = UIColor(white: 0.0, alpha: 0.725)
                segmentedControl.addTarget(self, action: #selector(didChangeValueForControl(_:)), forControlEvents: .ValueChanged)
                segmentedControl.frame = CGRect(x: 8.0, y: 8.0, width: view.frame.width - 16.0, height: 32.0)
                segmentedControl.tintColor = UIColor.whiteColor()
                segmentedControl.selectedSegmentIndex = 0
                segmentedControl.layer.cornerRadius = 4.0
                segmentedControl.layer.masksToBounds = true
                return segmentedControl
                }()
        }
        return {
            let newView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 32.0))
            newView.addSubview(filterSegmentedControl)
            return newView
            }()
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && eventsDataSource?.shouldDisplayTable() ?? false {
            return 48.0
        }
        return 0.0
    }

    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        // Don't allow selection of the no events cell.
        if eventsDataSource?.shouldDisplayNoEventsCell() ?? false {
            return nil
        }
        return indexPath
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        guard let event = eventsDataSource?.filteredEvents?[indexPath.row] else {
            return
        }
        eventDetailViewController.configure(event)
        navigationController?.pushViewController(eventDetailViewController, animated: true)
    }
}
