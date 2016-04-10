enum MenuOption: Int {
    case News
    case Events
    case Labs
    case Directory
    case DiskQuota
    case Settings

    static let allValues: [MenuOption] = [.News, .Events, .Labs, .Directory, .DiskQuota, .Settings]

    func title() -> String {
        switch self {
        case .News:
            return "News"
        case .Events:
            return "Events"
        case .Labs:
            return "Labs"
        case .Directory:
            return "Directory"
        case .DiskQuota:
            return "Disk Quota"
        case .Settings:
            return "Settings"
        }
    }
}

protocol MenuViewControllerDelegate {
    func menuOptionWillBeSelected(option: MenuOption) -> Bool
    func didSelectMenuOption(option: MenuOption)
}

class MenuViewController: UITableViewController {
    var delegate: MenuViewControllerDelegate?
    var selectedIndex: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    let menuCellReuseIdentifier = "MenuTableViewCell"
    
    var bottomExtent: CGFloat  {
        return tableView.rowHeight * CGFloat(MenuOption.allValues.count) + tableView.contentInset.top
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        edgesForExtendedLayout = .None
        view.backgroundColor = UIColor(white: 0.08, alpha: 1.0)

        tableView.scrollEnabled = false
        tableView.rowHeight = 60.0
        tableView.contentInset = UIEdgeInsets(top: 20.0, left: 0, bottom: 0 , right: 0)
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
        tableView.frame.size = CGSize(width: 0.75 * view.frame.width, height: tableView.frame.height)

        tableView.registerClass(MenuTableViewCell.self, forCellReuseIdentifier: menuCellReuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let cell = tableView.cellForRowAtIndexPath(selectedIndex)
        cell?.selected = true
    }

    // MARK:- Status Bar

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    override func prefersStatusBarHidden() -> Bool {
        return false
    }

    // MARK:- UITableView
    
    func setSelection(option: MenuOption, selected: Bool) {
        let indexPath = NSIndexPath(forRow: option.rawValue, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: option.rawValue, inSection: 0))
        
        if selected {
            let oldCell = tableView.cellForRowAtIndexPath(selectedIndex)
            oldCell?.selected = false
            
            selectedIndex = indexPath
            delegate?.didSelectMenuOption(option)
        }
        
        cell?.selected = selected
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(menuCellReuseIdentifier, forIndexPath:  indexPath) as! MenuTableViewCell
        let option = MenuOption(rawValue: indexPath.row) ?? .News

        cell.textLabel?.text = option.title()
        cell.menuType = option

        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOption.allValues.count
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let option = MenuOption(rawValue: indexPath.row) ?? .News
        let selected = delegate?.menuOptionWillBeSelected(option) ?? true
        
        setSelection(option, selected: selected)
    }
    
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        cell?.highlighted = true
    }
    
    override func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        cell?.highlighted = false
    }
}
