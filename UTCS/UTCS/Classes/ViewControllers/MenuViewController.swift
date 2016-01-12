enum MenuOption: Int {
    case News = 0,
    Events,
    Labs,
    Directory,
    DiskQuota,
    Settings

    static let allValues = [MenuOption.News, .Events, .Labs, .Directory, .DiskQuota, .Settings]

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
    func menuOptionWillTransitionToState(option: MenuOption, state: MenuViewController.MenuOptionState) -> MenuViewController.MenuOptionState
    func didSelectMenuOption(option: MenuOption)
}

class MenuViewController: UITableViewController {
    private var optionStates = [MenuOption: MenuOptionState]()
    var delegate: MenuViewControllerDelegate?
    var singleSelection = true
    var bottomExtent: CGFloat  {
        return tableView.rowHeight * CGFloat(MenuOption.allValues.count) + tableView.contentInset.top
    }

    enum MenuOptionState {
        case Selected,
        Tentative,
        Default
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        for option in MenuOption.allValues {
            optionStates[option] = .Default
        }

        edgesForExtendedLayout = .None
        view.backgroundColor = UIColor(white: 0.08, alpha: 1.0)

        tableView.scrollEnabled = false
        tableView.rowHeight = 60.0
        tableView.contentInset = UIEdgeInsets(top: 20.0, left: 0, bottom: 0 , right: 0)
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
        tableView.frame.size = CGSize(width: 0.75 * view.frame.width, height: tableView.frame.height)

        tableView.registerClass(MenuTableViewCell.self, forCellReuseIdentifier: "MenuTableViewCell")

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK:-

    func select(option: MenuOption) {
        if singleSelection {
            for otherOption in MenuOption.allValues where otherOption != option {
                optionStates[otherOption] = .Default
            }
        }
        optionStates[option] = .Selected
        tableView.reloadData()
    }

    func clearTentative() {
        for option in MenuOption.allValues
            where optionStates[option] == .Tentative {
                optionStates[option] = .Default
        }
        tableView.reloadData()
    }

    // MARK:- Status Bar

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    override func prefersStatusBarHidden() -> Bool {
        return false
    }

    // MARK:- UITableView

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuTableViewCell", forIndexPath:  indexPath)
        let option = MenuOption(rawValue: indexPath.row) ?? .News
        let state = optionStates[option] ?? .Default

        let cellTint: UIColor = {
            switch state {
            case .Selected:
            return UIColor.whiteColor()
            case .Default:
            return UIColor(white: 1.0, alpha: 0.5)
            case .Tentative:
                return UIColor(white: 1.0, alpha: 0.7)
            }
        }()

        cell.textLabel?.textColor =  cellTint
        cell.imageView?.tintColor = cellTint
        cell.textLabel?.text = option.title()

        var imageName = option.title().lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "")
        if state == .Selected {
            imageName = "\(imageName)-active"
        }
        cell.imageView?.image = UIImage(named: imageName)?.imageWithRenderingMode(.AlwaysTemplate)

        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOption.allValues.count
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let option = MenuOption(rawValue: indexPath.row) ?? .News
        let toState = delegate?.menuOptionWillTransitionToState(option, state: .Selected) ?? .Selected

        if toState == .Selected {
            select(option)
            delegate?.didSelectMenuOption(option)
        } else {
            optionStates[option] = toState
            tableView.reloadData()
        }

    }

}
