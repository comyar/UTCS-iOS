let searchBarBackgroundImageName = "searchBarBackground";


class DirectoryViewController: TableViewController, UISearchControllerDelegate, UTCSDataSourceDelegate {
    var appeared = false
    var errorView: ServiceErrorView!
    var searchController: UISearchController!
    var directoryDataSource: UTCSDirectoryDataSource! {
        get{
            return dataSource as! UTCSDirectoryDataSource!
        }
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        dataSource = UTCSDirectoryDataSource(service: UTCSDirectoryServiceName)
        directoryDataSource.delegate = self
        view.backgroundColor = UIColor.clearColor()
        showsNavigationBarSeparatorLine = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/*

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        self.dataSource = [[UTCSDirectoryDataSource alloc]initWithService:UTCSDirectoryServiceName];
        self.dataSource.delegate = self;
        
        self.view.backgroundColor = [UIColor clearColor];
        self.showsNavigationBarSeparatorLine = NO;
        
        self.searchBar = ({
            UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.width, 64.0)];
            searchBar.backgroundImage = [UIImage new];
            searchBar.placeholder = @"Search Directory";
            searchBar.scopeButtonTitles = @[@"All", @"Faculty", @"Staff", @"Graduate"];
            searchBar.scopeBarBackgroundImage = [UIImage new];
            searchBar.tintColor = [UIColor whiteColor];
            searchBar.searchTextPositionAdjustment = UIOffsetMake(8.0, 0.0);
            [searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:searchBarBackgroundImageName]
                                            forState:UIControlStateNormal];
            searchBar;
        });

        self.tableView.tableHeaderView = self.searchBar;
        self.tableView.alwaysBounceVertical = NO;
        self.tableView.sectionIndexColor = [UIColor whiteColor];
        self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
        self.tableView.dataSource = (UTCSDirectoryDataSource *)self.dataSource;
        
        self.dataSource.searchController.searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar
                                                                                                    contentsController:self];
        self.dataSource.searchController.searchDisplayController.searchResultsDataSource = (UTCSDirectoryDataSource *)self.dataSource;
        self.dataSource.searchController.searchDisplayController.searchResultsDelegate = self;
    }
    return self;
}

#pragma mark UIViewController Methods

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.hasAppeared) {
        self.appeared = YES;
        self.tableView.contentOffset = CGPointMake(0, self.tableView.tableHeaderView.height);
        [self configureAppearance];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self update];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchButton = ({
        UIButton *button = [UIButton bouncyButton];
        [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(self.view.width - 44.0, 0.0, 44.0, 44.0);
        
        UIImage *image = [[UIImage imageNamed:@"search"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.tintColor = [UIColor whiteColor];
        imageView.frame = button.bounds;
        [button addSubview:imageView];
        
        button;
    });
    
    
    self.serviceErrorView = ({
        ServiceErrorView *view = [[ServiceErrorView alloc]initWithFrame:CGRectZero];
        view.errorLabel.text = @"Ouch! Something went wrong.\n\nPlease check your network connection.";
        view.alpha = 0.0;
        view;
    });
    
    self.serviceErrorView.frame     = CGRectMake(0.0, 0.0, self.view.width, 0.5 * self.view.height);
    self.serviceErrorView.center    = CGPointMake(self.view.center.x, 0.9 * self.view.center.y);
    
    [self.view addSubview:self.serviceErrorView];
    [self.view addSubview:self.searchButton];
    [self.view bringSubviewToFront:self.searchButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.detailViewController = nil;
}

#pragma mark Buttons

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if (button == self.searchButton) {
        [self.tableView scrollRectToVisible:CGRectMake(0.0, 0.0, 1.0, 1.0) animated:NO];
        [self.searchBar becomeFirstResponder];
    }
}

#pragma mark Updating

- (void)update
{
    if ([self.dataSource shouldUpdate]) {
        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        progressHUD.mode = MBProgressHUDModeIndeterminate;
        progressHUD.labelText = @"Syncing";
        
        [self.dataSource updateWithArgument:nil completion:^(BOOL success, BOOL cacheHit) {
            
            if (success && !cacheHit) {
                [((UTCSDirectoryDataSource *)self.dataSource) buildFlatDirectory];
                [self.tableView reloadData];
                self.tableView.contentOffset = CGPointMake(0, self.tableView.tableHeaderView.height);
            }
            
            [UIView animateWithDuration:0.3 animations:^{
                self.searchButton.alpha     = success;
                self.tableView.alpha        = success;
                self.serviceErrorView.alpha = !success;
            }];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
}

#pragma mark UITableViewDelegate Methpds

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    if (offset < 0.0 && [self.tableView.subviews count] > 0) {
        UIView *subview = self.tableView.subviews[0];
        subview.alpha = 0.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSDirectoryPerson *person = nil;
    if (tableView == self.dataSource.searchController.searchDisplayController.searchResultsTableView) {
        person = self.dataSource.searchController.searchResults[indexPath.row];
    } else {
        person = self.dataSource.data[indexPath.section][indexPath.row];
    }
    
    if (!self.detailViewController) {
        self.detailViewController = [DirectoryDetailViewController new];
    }
    
    self.detailViewController.person = person;
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.width - 8.0, 16.0)];
            label.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
            label.text = [NSString stringWithFormat:@""];
            label.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
            label.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
            label;
        });
    } else if (tableView == self.tableView) {
        UTCSDirectoryPerson *person = self.dataSource.data[section][0];
        NSString *letter = [[person.lastName substringToIndex:1]uppercaseString];
        return ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.width - 8.0, 16.0)];
            label.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
            label.text = [NSString stringWithFormat:@"   %@", letter];
            label.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
            label.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
            label;
        });
    }
    return nil;
}

#pragma mark UTCSDataSourceCacheDelegate Methods

- (NSDictionary *)objectsToCacheForDataSource:(UTCSDataSource *)dataSource
{
    return @{UTCSDirectoryCacheKey: self.dataSource.data,
             UTCSDirectoryFlatCacheKey :((UTCSDirectoryDataSource *)self.dataSource).flatDirectory};
}

#pragma mark Appearance

- (void)configureAppearance
{
    [self configureSearchBarWithRoot:self.searchBar];
}

- (void)configureSearchBarWithRoot:(UIView *)root
{
    // Recursively change the appearance of any textfields in a search bar (should only be one...)
    if ([root isKindOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField *)root;
        NSDictionary *searchBarPlaceholderAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithWhite:1.0 alpha:0.5]};
        NSAttributedString *searchBarPlaceholder = [[NSAttributedString alloc]initWithString:@"Search"
                                                                                  attributes:searchBarPlaceholderAttributes];
        textField.attributedPlaceholder = searchBarPlaceholder;
        textField.textColor = [UIColor whiteColor];
        textField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
        textField.clearButtonMode = UITextFieldViewModeNever;
    } else {
        for (UIView *subview in root.subviews) {
            [self configureSearchBarWithRoot:subview];
        }
    }
}

@end*/
