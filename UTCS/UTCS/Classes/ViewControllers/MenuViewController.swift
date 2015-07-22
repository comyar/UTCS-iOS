@objc enum MenuOption: Int {
    case News = 0,
    Events,
    Labs,
    Directory,
    DiskQuota,
    Settings
}

@objc protocol MenuViewControllerDelegate {
    func didSelectMenuOption(option: MenuOption)
}



class MenuViewController: UITableViewController {
    let menuOptions = ["News", "Events", "Labs", "Directory", "Disk Quota", "Settings"]
    var activeRow: Int?
    var delegate: MenuViewControllerDelegate?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        title = "Menu"
        edgesForExtendedLayout = .None
        view.backgroundColor = UIColor(white: 0.08, alpha: 1.0)

        tableView.scrollEnabled = false
        tableView.rowHeight = 60.0
        tableView.contentInset = UIEdgeInsets(top: 0.05 * view.frame.height, left: 0 ,bottom: 0 ,right: 0)
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
        tableView.frame.size = CGSize(width: 0.75 * view.frame.width, height: tableView.frame.height)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    override func prefersStatusBarHidden() -> Bool {
        return false
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MenuTableViewCell")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "MenuTableViewCell")
            cell?.selectionStyle = .None
            cell?.backgroundColor = UIColor.clearColor()
            cell?.textLabel?.font = UIFont.systemFontOfSize(28.0)
        }
        cell?.textLabel?.textColor = (indexPath.row == activeRow) ? UIColor.whiteColor() : UIColor(white: 1.0, alpha: 0.5)
        cell?.imageView?.tintColor = cell?.textLabel?.textColor
        cell?.textLabel!.text = menuOptions[indexPath.row]
        var imageName = cell?.textLabel!.text?.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "")
        if indexPath.row == activeRow {
            imageName = "\(imageName!)-active"
        }
        cell?.imageView?.image = UIImage(named: imageName!)?.imageWithRenderingMode(.AlwaysTemplate)
        return cell!
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        activeRow = indexPath.row
        tableView.reloadData()
        let option: MenuOption
        switch indexPath.row {
        case 0:
            option = .News
        case 1:
            option = .Events
        case 2:
            option = .Labs
        case 3:
            option = .Directory
        case 4:
            option = .DiskQuota
        case 5:
            option = .Settings
        default:
            option = .News
        }
        delegate?.didSelectMenuOption(option)
    }

}

