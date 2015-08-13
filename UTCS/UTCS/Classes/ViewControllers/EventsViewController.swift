let serviceName = "events";


class EventsViewController: HeaderTableViewController, DataSourceDelegate, StarredEventsViewControllerDelegate {
    // Name of the background image
    let backgroundImageName = "eventsBackground";
    var eventsDataSource: EventsDataSource? {
        get {
            return dataSource as? EventsDataSource
        }
}
    var filterSegmentedControl: UISegmentedControl!
    var filters = [(EventsDataSource.EventType.All, UIColor.whiteColor()), (.Talks, UIColor.utcsEventTalkColor()), (.Careers, UIColor.utcsEventCareersColor()),(.Orgs, UIColor.utcsEventStudentOrgsColor())]
    var filterButtonImageView: UIImageView!
    var starListButton: UIButton!
    var starredEventsViewController: StarredEventsViewController!
    var eventDetailViewController: UTCSEventsDetailViewController?

    override init(style: UITableViewStyle) {
        super.init(style: style)
        dataSource = EventsDataSource()
        dataSource!.delegate = self
        tableView.dataSource = eventsDataSource
        backgroundImageView.image = UIImage.cacheless_imageNamed(backgroundImageName)

        activeHeaderView = NSBundle.mainBundle().loadNibNamed("ActiveHeaderView", owner: self, options: [:])[0] as! ActiveHeaderView
        activeHeaderView.sectionHeadLabel.text = "UTCS Events"
        activeHeaderView.subtitleLabel.text = "What Starts Here Changes the World"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)

    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        update()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
            return button
        }()
        view.addSubview(starListButton)
        view.bringSubviewToFront(starListButton)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        eventDetailViewController = nil
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

    func didChangeValueForControl(control: UIControl){
        if control == filterSegmentedControl {
            let index = filterSegmentedControl.selectedSegmentIndex
            let filterType = filters[index].0
            let filterColor = filters[index].1
            filterEventsWithType(filterType)
            filterSegmentedControl.tintColor = filterColor
        }
    }

    func filterEventsWithType(type: EventsDataSource.EventType) {
        if type != eventsDataSource!.currentFilterType {
            let indexPaths = eventsDataSource!.filterEventsWithType(type)
            let addIndexPaths = indexPaths[UTCSEventsFilterAddIndex]
            let removeIndexPaths = indexPaths[UTCSEventsFilterRemoveIndex]
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths(removeIndexPaths, withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths(addIndexPaths, withRowAnimation: .Fade)
            tableView.endUpdates()
        }
    }

    func update(){
        activeHeaderView.showActiveAnimation(true)
        dataSource!.updateWithArgument(nil) { (success, cacheHit) -> Void in
            self.activeHeaderView.showActiveAnimation(false)
            if self.eventsDataSource?.eventData?.count ?? 0 > 0 {
                let updateString = NSDateFormatter.localizedStringFromDate(self.dataSource!.updated!, dateStyle: .LongStyle, timeStyle: .MediumStyle)
                self.activeHeaderView.updatedLabel.text = "Updated \(updateString)"
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

    func starredEventsViewController(starredEventsViewController: StarredEventsViewController, didSelectEvent event: UTCSEvent){
        if eventDetailViewController == nil {
            eventDetailViewController = UTCSEventsDetailViewController()
        }
        eventDetailViewController!.event = event
        navigationController?.pushViewController(eventDetailViewController!, animated: true)
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 && dataSource!.data!.count > 0 {
            if filterSegmentedControl == nil {

                filterSegmentedControl = {
                    let unzipped: [String] = {
                        var keys = [String]()
                        for item in filters {
                            keys.append(item.0.rawValue)
                        }
                        return keys
                    }()
                    let segmentedControl = UISegmentedControl(items: unzipped)
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
        return nil
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && dataSource?.data?.count ?? 0 > 0 {
            return 48.0
        }
        return 0.0
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       return 48.0
    }
    override func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setHighlighted(false, animated: true)
    }
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setHighlighted(true, animated: true)
    }
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 168.0
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let event = eventsDataSource!.filteredEvents[indexPath.row]
        if !(eventDetailViewController != nil) {
            eventDetailViewController = UTCSEventsDetailViewController()
        }
        eventDetailViewController!.event = event
        navigationController?.pushViewController(eventDetailViewController!, animated: true)
    }
    func objectsToCacheForDataSource(dataSource: DataSource!) -> [NSObject : AnyObject]! {
        return [UTCSEventsDataSourceCacheKey: dataSource.data!]
    }

}