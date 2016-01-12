import MBProgressHUD

class DirectoryViewController: TableViewController {
    var appeared = false
    var errorView: ServiceErrorView!
    var detailViewController: DirectoryDetailViewController?
    var directoryDataSource: DirectoryDataSource? {
        return dataSource as? DirectoryDataSource
    }

    // MARK:- Initialization

    override init(style: UITableViewStyle) {
        super.init(style: style)
        dataSource = DirectoryDataSource()
        tableView.dataSource = directoryDataSource

        backgroundImageName = "Directory"
        title = "Directory"
        needsSectionHeaders = true

        tableView.sectionIndexColor = UIColor.whiteColor()
        tableView.sectionIndexBackgroundColor = UIColor.clearColor()
        update()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        dataSource.updateWithArgument(nil) { (success, cacheHit) -> Void in
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

    // MARK:- UITableViewDelegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let person = directoryDataSource?.directoryPeopleSections![indexPath.section][indexPath.row]
        if detailViewController == nil {
            detailViewController = DirectoryDetailViewController()
        }
        detailViewController!.person = person
        navigationController?.pushViewController(detailViewController!, animated: true)
   }

    override func textForHeaderInSection(section: Int) -> String {
        guard let person = directoryDataSource?.directoryPeopleSections?[section][0] else {
            return ""
        }

        let lastName = person.lastName as NSString
        let letter = lastName.substringWithRange(NSRange(location: 0, length: 1))
        return letter
    }

}
