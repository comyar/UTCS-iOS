import MBProgressHUD

class DirectoryViewController: TableViewController, DataSourceDelegate {
    var appeared = false
    var errorView: ServiceErrorView!
    var detailViewController: DirectoryDetailViewController?
    var directoryDataSource: DirectoryDataSource? {
        return dataSource as? DirectoryDataSource
    }


    override init(style: UITableViewStyle) {
        super.init(style: style)
        dataSource = DirectoryDataSource()
        directoryDataSource?.delegate = self

        backgroundImageName = "Directory"
        view.backgroundColor = UIColor.clearColor()
        showsNavigationBarSeparatorLine = false
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        //searchController.searchBar.scopeButtonTitles = ["All", "Faculty", "Staff", "Graduate"]
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor = UIColor.whiteColor()
        searchController.searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 8.0, vertical: 0.0)
        searchController.searchBar.setSearchFieldBackgroundImage(UIImage(named: searchBarBackgroundImageName), forState: .Normal)

        directoryDataSource.searchController = searchController

        tableView.tableHeaderView = searchController.searchBar
        tableView.sectionIndexColor = UIColor.whiteColor()
        tableView.sectionIndexBackgroundColor = UIColor.clearColor()
        tableView.tableHeaderView?.backgroundColor = UIColor.clearColor()
        tableView.dataSource = directoryDataSource
        backgroundImageName = "directoryBackground"
        update()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = menuButton
        errorView = {
            let view = ServiceErrorView.loadFromNib()
            view.errorLabel.text = "Ouch! Something went wrong.\n\nPlease check your network connection"
            view.alpha = 0.0
            return view
        }()
        errorView.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 0.5 * view.frame.height)
        errorView.center = CGPoint(x: view.center.x, y: 0.9 * view.center.y)
        view.addSubview(errorView)
        update()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        detailViewController = nil
    }

    func update() {
        guard let dataSource = directoryDataSource else {
            return
        }
        let progressHUD = MBProgressHUD.showHUDAddedTo(view, animated: true)
        progressHUD.mode = .Indeterminate
        progressHUD.labelText = "Syncing"
        dataSource.updateWithArgument(nil){ (success, cacheHit) -> Void in
            if success && !cacheHit {
               dataSource.directoryPeopleSections = dataSource.directoryPeople.createSectionedRepresentation()
                self.tableView.reloadData()
            }
            UIView.animateWithDuration(0.3) {
                let successValue: CGFloat = success ? 1.0 : 0.0
                self.tableView.alpha = successValue
                self.errorView.alpha = successValue - 1.0
            }
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }

    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64.0
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let person = directoryDataSource?.directoryPeopleSections![indexPath.section][indexPath.row]
        if detailViewController == nil {
            detailViewController = DirectoryDetailViewController()
        }
        detailViewController!.person = person
        navigationController?.pushViewController(detailViewController!, animated: true)
   }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let person = directoryDataSource?.directoryPeopleSections?[section][0] else {
            return UIView()
        }
        let lastName = person.lastName as NSString
        let letter = lastName.substringWithRange(NSRange(location: 0, length: 1))
        return {
            let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width - 8.0, height: 24.0))
            label.font = UIFont.systemFontOfSize(16.0)
            label.text = letter
            label.textColor = UIColor(white: 1.0, alpha: 1.0)
            label.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
            return label
        }()
    }

    //Required for viewForHeaderInSection to be called
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24.0
    }
}
