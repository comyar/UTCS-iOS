class SettingsLicenseViewController: TableViewController {
    var license: String!
}

/*
#import "UTCSSettingsLicenseViewController.h"

@interface UTCSSettingsLicenseViewController ()

@property (nonatomic) NSString *licenseText;

@end

@implementation UTCSSettingsLicenseViewController

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return self;
}

- (void)setLicense:(NSString *)license
{
    _license = license;
    NSString *licenseFilename = [self.license stringByAppendingString:@"-license"];
    NSString *licensePath = [[NSBundle mainBundle]pathForResource:licenseFilename ofType:@"txt"];
    self.licenseText = [NSString stringWithContentsOfFile:licensePath encoding:NSUTF8StringEncoding error:nil];
    self.licenseText = [[self.licenseText componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]
                        componentsJoinedByString:@" "];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.menuButton.hidden = YES;
}

#pragma mark UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSSettingsLicenseTableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"UTCSSettingsLicenseTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cell.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    cell.textLabel.text = self.licenseText;
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.license;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Estimate height of a news story title
    CGRect rect = [self.licenseText boundingRectWithSize:CGSizeMake(self.tableView.width - 32.0, CGFLOAT_MAX)
                                                 options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                              attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}
                                                 context:nil];
    return ceilf(rect.size.height);
}


@end
*/