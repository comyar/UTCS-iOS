let serviceName = "events"


final class EventsViewController: HeaderTableViewController, StarredEventsViewControllerDelegate {

    var eventsDataSource: EventsDataSource? {
        return dataSource as? EventsDataSource
    }
    var filterSegmentedControl: UISegmentedControl!
    var segments = [Event.Category.All, .Orgs, .Talks, .Careers]
    var filterButtonImageView: UIImageView!
    var starListButton: UIBarButtonItem!
    var starredEventsViewController: StarredEventsViewController!
    let eventDetailViewController = UTCSEventsDetailViewController()

    init() {
        super.init(style: .Plain)
        dataSource = EventsDataSource()

        tableView.dataSource = eventsDataSource
        tableView.estimatedRowHeight = 48
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: EventsTableViewCellIdentifier)
        backgroundImageName = "Events"
        title = "Events"

        activeHeaderView.sectionHeadLabel.text = "UTCS Events"
        activeHeaderView.subtitleLabel.text = NewsViewController.headerSubtitleText
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        update()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = menuButton

        starListButton = {
            let button = UIButton.bouncyButton()
            button.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
            button.center = CGPoint(x: view.frame.width - 33.0, y: 22.0)
            let image = UIImage(named: "starlist")?.imageWithRenderingMode(.AlwaysTemplate)
            let imageView = UIImageView(image: image)
            imageView.tintColor = UIColor.whiteColor()
            imageView.frame = button.bounds
            button.addSubview(imageView)
            button.addTarget(self, action: "didTouchUpInsideButton:", forControlEvents: .TouchUpInside)
            return UIBarButtonItem(customView: button)
        }()
        navigationItem.rightBarButtonItem = starListButton

    }

    func didTouchUpInsideButton(button: UIButton) {
        if button == starListButton {
            if starredEventsViewController == nil {
                starredEventsViewController = StarredEventsViewController()
                starredEventsViewController.backgroundImageView.image = backgroundImageView.image
                starredEventsViewController.delegate = self
            }
            navigationController?.presentViewController(starredEventsViewController, animated: true, completion: nil)
        }
    }

    func didChangeValueForControl(control: UIControl) {
        if control == filterSegmentedControl {
            let index = filterSegmentedControl.selectedSegmentIndex
            let filterType = segments[index]
            let filterColor = EventsDataSource.typeColorMapping[filterType]
            filterEventsWithType(filterType)
            filterSegmentedControl.tintColor = filterColor
        }
    }

    func filterEventsWithType(type: Event.Category) {
        let (addIndexPaths, removeIndexPaths) = eventsDataSource!.filterEventsWithType(type)
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths(removeIndexPaths, withRowAnimation: .Fade)
        tableView.insertRowsAtIndexPaths(addIndexPaths, withRowAnimation: .Fade)
        tableView.endUpdates()

    }

    func update() {
        activeHeaderView.showActiveAnimation(true)
        eventsDataSource!.updateWithArgument(nil) { (success, cacheHit) -> Void in
            self.activeHeaderView.showActiveAnimation(false)
            if self.eventsDataSource?.eventData?.count ?? 0 > 0 {
                self.lastUpdated = self.dataSource?.updated
                if !cacheHit {
                    self.tableView.reloadData()
                } else {
                    if success {
                        self.activeHeaderView.updatedLabel.text = "No events available"
                    } else {
                        self.activeHeaderView.updatedLabel.text = "Please check your network connection."
                    }
                }
            }
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.activeHeaderView.downArrowImageView.alpha = success ? 1.0 : 0.0
            })
        }
    }

    func starredEventsViewController(starredEventsViewController: StarredEventsViewController, didSelectEvent event: Event) {
        eventDetailViewController.event = event
        navigationController?.pushViewController(eventDetailViewController, animated: true)
    }

    // MARK:- UITableView

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 && eventsDataSource?.filteredEvents?.count > 0 else {
            return nil
        }
        if filterSegmentedControl == nil {

            filterSegmentedControl = {
                let segmentNames = segments.map({ (category) -> String in
                    return category.rawValue
                })
                let segmentedControl = UISegmentedControl(items: segmentNames)
                segmentedControl.backgroundColor = UIColor(white: 0.0, alpha: 0.725)
                segmentedControl.addTarget(self, action: "didChangeValueForControl:", forControlEvents: .ValueChanged)
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
        if section == 0 && eventsDataSource?.filteredEvents?.count ?? 0 > 0 {
            return 48.0
        }
        return 0.0
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        guard let event = eventsDataSource?.filteredEvents?[indexPath.row] else {
            return
        }
        eventDetailViewController.event = event
        navigationController?.pushViewController(eventDetailViewController, animated: true)
    }

}
