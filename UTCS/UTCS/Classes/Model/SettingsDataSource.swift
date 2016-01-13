let settingSwitchCellIdentifier = "switchCell"
let settingsCellIdentifier = "settingsCell"
let settingsSegmentedCellIdentifier = "segmentedCell"

class SettingsDataSource: NSObject, UITableViewDataSource {
    let sectionTitles = ["Settings", "Info", "Legal"]
    let infoTitles = ["Legal", "About"]
    let socialTitles = ["Facebook", "Twitter"]

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return infoTitles.count
        case 2:
            return socialTitles.count
        default:
            return 0
        }
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
}
/*

#pragma mark - Imports





#pragma mark - UTCSSettingsDataSource Class Extension

@interface UTCSSettingsDataSource ()

// Titles of the table view's sections.
@property (nonatomic) NSArray       *sectionTitles;

// Titles of the table view's info section
@property (nonatomic) NSArray       *infoTitles;

// Titles of the table view's social section
@property (nonatomic) NSArray       *socialTitles;

@end


#pragma mark - UTCSSettingsDataSource Implementation

@implementation UTCSSettingsDataSource

#pragma mark Creating a Settings Data Source

- (instancetype)init
{
    if (self = [super init]) {
        self.sectionTitles  = @[@"Settings", @"Info", @"Social"];
        self.infoTitles     = @[@"Legal", @"About"];
        self.socialTitles   = @[@"Facebook", @"Twitter"];
    }
    return self;
}

#pragma mark UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UTCSSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UTCSSettingsSwitchTableViewCellIdentifier];
            if (!cell) {
                cell = [[UTCSSwitchTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                                             reuseIdentifier:UTCSSettingsSwitchTableViewCellIdentifier];

            }
            [cell.cellSwitch addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
            cell.cellSwitch.on = [UTCSStateManager sharedManager].eventNotifications;
            cell.cellSwitch.tag = 0;
            cell.textLabel.text         = @"Event Notifications";
            cell.detailTextLabel.text   = @"Get notifications an hour before the start of starred events";
            returnCell = cell;
        } else if (indexPath.row == 1) {
            UTCSSegmentedControlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UTCSSettingsSegmentedControlTableViewCellIdentifier];
            if (!cell) {
                cell = [[UTCSSegmentedControlTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                                               reuseIdentifier:UTCSSettingsSegmentedControlTableViewCellIdentifier];
            }
            cell.textLabel.text = @"Preferred Lab";
            cell.segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"Third Floor", @"Basement"]];
            [cell.segmentedControl addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
            cell.segmentedControl.selectedSegmentIndex = [UTCSStateManager sharedManager].preferredLab;
            cell.segmentedControl.tag = 1;
            returnCell = cell;
        }
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UTCSSettingsTableViewCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:UTCSSettingsTableViewCellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        }

        if (indexPath.section == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = self.infoTitles[indexPath.row];
            cell.imageView.image = nil;
        } else if (indexPath.section == 2) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = self.socialTitles[indexPath.row];
            NSString *imageName = [self.socialTitles[indexPath.row]lowercaseString];
            cell.imageView.image = [[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            cell.imageView.tintColor = [UIColor whiteColor];
        }
        returnCell = cell;
    }
    return returnCell;
}



#pragma mark Controls

- (void)didChangeValue:(UIControl *)control
{
    if (control.tag == 0) {
        [UTCSStateManager sharedManager].eventNotifications = ((UISwitch *)control).selected;
        if ([UTCSStateManager sharedManager].eventNotifications) {
            [[UTCSStarredEventsManager sharedManager]enableNotifications];
        } else {
            [[UTCSStarredEventsManager sharedManager]disableNotifications];
        }
    } else if (control.tag == 1) {
        [UTCSStateManager sharedManager].preferredLab = ((UISegmentedControl *)control).selectedSegmentIndex;
    }
}

@end
*/
