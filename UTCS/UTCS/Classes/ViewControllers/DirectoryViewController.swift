import MBProgressHUD
let searchBarBackgroundImageName = "searchBarBackground";

class DirectoryViewController: TableViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, DataSourceDelegate {
    var appeared = false
    var errorView: ServiceErrorView!
    var searchController: UISearchController!
    var searchButton: UIButton!
    var detailViewController: DirectoryDetailViewController?
    var directoryDataSource: DirectoryDataSource! {
        get{
            return dataSource as! DirectoryDataSource!
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewStyle) {
        super.init(style: style)
        dataSource = DirectoryDataSource()
        directoryDataSource.delegate = self

        backgroundImageName = "directoryBackground"
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

        //tableView.registerNib(, forCellReuseIdentifier: )
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if appeared == false {
            appeared = true
            tableView.contentOffset = CGPoint(x: 0.0, y: tableView.tableHeaderView!.frame.height)
            configureAppearance()
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        update()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton = {
            let button = UIButton.bouncyButton()
            button.addTarget(self, action: "didTouchUpInsideButton:", forControlEvents: .TouchUpInside)
            button.frame = CGRect(x: self.view.frame.width - 44.0, y: 0.0, width: 44.0, height: 44.0)
            let image = UIImage(named: "search")?.imageWithRenderingMode(.AlwaysTemplate)
            let imageView = UIImageView(image: image)
            imageView.tintColor = UIColor.whiteColor()
            imageView.frame = button.bounds
            button.addSubview(imageView)
            return button
        }()
        errorView = {
            let view = ServiceErrorView.loadFromNib()
            view.errorLabel.text = "Ouch! Something went wrong.\n\nPlease check your network connection"
            view.alpha = 0.0
            return view
        }()
        errorView.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 0.5 * view.frame.height)
        errorView.center = CGPoint(x: view.center.x, y: 0.9 * view.center.y)
        view.addSubview(errorView)
        view.addSubview(searchButton)
        view.bringSubviewToFront(searchButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        detailViewController = nil
    }

    func didTouchUpInsideButton(button: UIButton) {
        if button == searchButton {
            tableView.scrollRectToVisible(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0), animated: false)
            searchController.searchBar.becomeFirstResponder()
        }
    }
    func update(){
        let progressHUD = MBProgressHUD.showHUDAddedTo(view, animated: true)
        progressHUD.mode = .Indeterminate
        progressHUD.labelText = "Syncing"
        dataSource?.updateWithArgument(nil){ (success, cacheHit) -> Void in
            if success && !cacheHit {
                self.directoryDataSource.directoryPeopleSections = self.directoryDataSource.directoryPeople.createSectionedRepresentation()
                self.tableView.reloadData()
                self.tableView.contentOffset = CGPoint(x: 0.0, y: self.tableView.tableHeaderView!.frame.height)
            }
            UIView.animateWithDuration(0.3){
                let successValue: CGFloat = success ? 1.0 : 0.0
                self.searchController.searchBar.alpha = successValue
                self.tableView.alpha = successValue
                self.errorView.alpha = successValue - 1.0
            }
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }

    }
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset < 0.0 && tableView.subviews.count > 0 {
            let subview = tableView.subviews[0]
            subview.alpha = 0.0
        }
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64.0
    }
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setHighlighted(true, animated: true)
    }
    override func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setHighlighted(false, animated: true)
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let person: DirectoryPerson
        if searchController.active {
            person = directoryDataSource.filtered[indexPath.row]
        } else {
            person = directoryDataSource.directoryPeopleSections![indexPath.section][indexPath.row]
        }
        if detailViewController == nil {
            detailViewController = DirectoryDetailViewController()
        }
        detailViewController!.person = person
        navigationController?.pushViewController(detailViewController!, animated: true)
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !searchController.active && tableView == self.tableView else {
            return nil
        }

        let person = directoryDataSource.directoryPeopleSections![section][0]
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
    func configureAppearance(){
        configureSearchBarWithRoot(searchController.searchBar)
    }
    func configureSearchBarWithRoot(root: UIView){
        if root is UITextField {
            let field = root as! UITextField
            let placeholderAttributes = [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.5)]
            let searchBarPlaceholder = NSAttributedString(string: "Search", attributes: placeholderAttributes)
            field.attributedPlaceholder = searchBarPlaceholder
            field.textColor = UIColor.whiteColor()
            field.font = UIFont.systemFontOfSize(20.0, weight: 100.0)
            field.clearButtonMode = .Never
        } else {
            for subview in root.subviews {
                configureSearchBarWithRoot(subview)
            }
        }
    }

    //MARK: - Search
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        filterContentForSearchText(searchString!, scope: searchController.searchBar.selectedScopeButtonIndex)
        tableView.reloadData()
    }
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int){
        updateSearchResultsForSearchController(searchController)
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        updateSearchResultsForSearchController(searchController)
    }

    func filterContentForSearchText(searchText: String, scope: Int) {
        let buttonTitles = searchController.searchBar.scopeButtonTitles!
        let scopeString = buttonTitles[scope]
        directoryDataSource.filtered = directoryDataSource.directoryPeople.filter({person -> Bool in
            let categoryMatch = (scopeString == "All") || (person.type == scopeString)
            if searchText != "" {
                let stringMatch = person.fullName.rangeOfString(searchText, options: .CaseInsensitiveSearch)
                return categoryMatch && (stringMatch != nil)
            } else {
                return categoryMatch
            }
        })
    }

}
