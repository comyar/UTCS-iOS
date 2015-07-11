let serviceName = "events";

// Name of the background image
let backgroundImageName = "eventsBackground";


class UTCSEventsViewController: HeaderTableViewController, UTCSDataSourceDelegate, UTCSStarredEventsViewControllerDelegate {
    var dataSource: UTCSEventsDataSource!
    var filterSegmentedControl: UISegmentedControl!
    var filters = [("All", UIColor.whiteColor()), ("Talks", UIColor.utcsEventTalkColor()), ("Careers", UIColor.utcsEventCareersColor()),("Orgs", UIColor.utcsEventStudentOrgsColor())]
    var filterButtonImageView: UIImageView!
    var starListButton: UIButton!
    var starredEventsViewController: UTCSStarredEventsViewController!
    var eventDetailViewController: UTCSEventsDetailViewController?

    init(style: UITableViewStyle){
        return super.init
    }

    init() {
        self.init(style: .Plain)
    }
    init(style: UITableViewStyle) {
        super.init(style: style)
        dataSource = UTCSEventsDataSource(service: serviceName)
        dataSource.delegate = self
        tableView.dataSource = dataSource
        backgroundImageView = UIImage.cacheless_imageNamed(backgroundImageName)

        activeHeaderView = NSBundle.mainBundle().loadNibNamed("ActiveHeaderView", owner: self, options: [:])[0]
        activeHeaderView.sectionHeadLabel.text = "UTCS Events"
        activeHeaderView.subtitleLabel.text = "What Starts Here Changes the World"
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
            button.center = CGPoint(x: view.width - 33.0, y: 22.0)
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
    override func didTouchDownInsideButton(button: UIButton) {
        if button == starListButton {
            if starredEventsViewController == nil {
                starredEventsViewController = UTCSStarredEventsViewController()
                starredEventsViewController.backgroundImageView.image = backgroundImageView
                starredEventsViewController.delegate = self
            }
            navigationController?.presentViewController(starredEventsViewController, animated: true, completion: nil)
        }
    }

    override func didChangeValueForKey(key: String) {
        if control == filterSegmentedControl {
            let index = filterSegmentedControl.selectedSegmentIndex
            let filterType = filters[index].0
            let filterColor = filters[index].1
            filterEventsWithType(filterType)
            filterSegmentedControl.tintColor = filterColor
        }
    }

    func filterEventsWithType(type: String) {
        if type != dataSource.currentFilterType {
            let indexPaths = dataSource.filterEventsWithType(type)
            let addIndexPaths = indexPaths[UTCSEventsFilterAddName]
            let removeIndexPaths = indexPaths[UTCSEventsFilterRemoveName]
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths(removeIndexPaths, withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths(addIndexPaths, withRowAnimation: .Fade)
            tableView.endUpdates()
        }
    }

    func update(){
        activeHeaderView.showActiveAnimation(true)
        dataSource.updateWithArgument(nil) { (success, cacheHit) -> Void in
            activeHeaderView.showActiveAnimation(false)
            if dataSource.data.count > 0 {
                let updateString = NSDateFormatter.localizedStringFromDate(dataSource.updated, dateStyle: .LongStyle, timeStyle: .MediumStyle)
                activeHeaderView.updatedLabel.text = "Updated \(updateString)"
                if !cacheHit {
                    dataSource.prepareFilter()
                    tableView.reloadData()
                } else {
                    if success {
                        activeHeaderView.updatedLabel.text = "No events available"
                    } else {
                        activeHeaderView.updatedLabel.text = "Please check your network connection."
                    }
                }
            }
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                activeHeaderView.downArrowImageView.alpha = success ? 1.0 : 0.0
            })
        }
    }

    func starredEventsViewController(starredEventsViewController: UTCSStarredEventsViewController, didSelectEvent event: UTCSEvent){
        if eventDetailViewController == nil {
            eventDetailViewController = UTCSEventsDetailViewController()
        }
        eventDetailViewController.event = event
        navigationController?.pushViewController(eventDetailViewController, animated: true)
    }

    // Given sequence of 2-tuples, return two arrays
    func unzip<T, U>(sequence: SequenceOf<(T, U)>) -> ([T], [U]) {
        var t = Array<T>()
        var u = Array<U>()
        for (a, b) in sequence {
            t.append(a)
            u.append(b)
        }
        return (t, u)
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 && dataSource.data.count > 0 {
            if filterSegmentedControl == nil {
                filterSegmentedControl = {
                    let segmentedControl = UISegmentedControl(items: unzip(filter)[0])
                    segmentedControl.backgroundColor = UIColor(white: 0.0, alpha: 0.725)
                    segmentedControl.addTarget(self, action: "didChangeValueForControl:", forControlEvents: .ValueChanged)
                    segmentedControl.frame = 
                }()
            }
        }
    }

}


#pragma mark UITableViewDelegate Methods

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 && [self.dataSource.data count] > 0) {
        if (!self.filterSegmentedControl) {
            self.filterSegmentedControl = ({
                UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:self.filterTypes];
                segmentedControl.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.725];
                [segmentedControl addTarget:self action:@selector(didChangeValueForControl:) forControlEvents:UIControlEventValueChanged];
                segmentedControl.frame = CGRectMake(8.0, 8.0, self.view.width - 16.0, 32.0);
                segmentedControl.tintColor = [UIColor whiteColor];
                segmentedControl.selectedSegmentIndex = 0;
                segmentedControl.layer.cornerRadius = 4.0;
                segmentedControl.layer.masksToBounds = YES;
                segmentedControl;
            });
        }
        
        return ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.width, 32.0)];
            [view addSubview:self.filterSegmentedControl];
            view;
        });
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 && [self.dataSource.data count] > 0) {
        return 48.0;
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSEvent *event = self.dataSource.filteredEvents[indexPath.row];
    
    // Estimate height of event name
    CGRect rect = [event.name boundingRectWithSize:CGSizeMake(self.tableView.width - 32.0, CGFLOAT_MAX)
                                                options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                             attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]}
                                                context:nil];
    return MIN(ceilf(rect.size.height), 66.0) + 55.0;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setHighlighted:YES animated:YES];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setHighlighted:NO animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 168.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UTCSEvent *event = self.dataSource.filteredEvents[indexPath.row];
    if (!self.eventDetailViewController) {
        self.eventDetailViewController = [UTCSEventsDetailViewController new];
    }
    self.eventDetailViewController.event = event;
    [self.navigationController pushViewController:self.eventDetailViewController animated:YES];
}

#pragma mark UTCSDataSourceDelegate Methods

- (NSDictionary *)objectsToCacheForDataSource:(UTCSDataSource *)dataSource
{
    return @{UTCSEventsDataSourceCacheKey: dataSource.data};
}

@end
