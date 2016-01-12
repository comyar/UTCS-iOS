class SettingsViewController: TableViewController {
    let facebookAppURL = NSURL(string: "fb://page/272565539464226")!
    let facebookWebURL = NSURL(string: "https://fb.me/UTCompSci")!
    let twitterAppURL = NSURL(string: "twitter://user?screen_name=utcompsci")!
    let twitterWebURL = NSURL(string: "https://twitter.com/UTCompSci")!

    var settingsDataSource: SettingsDataSource {
        return dataSource as! SettingsDataSource
    }
    var legalViewController: SettingsLegalViewController?
    var aboutViewController: SettingsAboutViewController?

    convenience init() {
        self.init(style: .Grouped)
    }

    override init(style: UITableViewStyle) {
        super.init(style: style)
        dataSource = SettingsDataSource()
        tableView.dataSource = settingsDataSource
        backgroundImageName = "Settings"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = menuButton
    }

    override func didReceiveMemoryWarning() {
        legalViewController = nil
        aboutViewController = nil
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                if legalViewController == nil {
                    legalViewController = SettingsLegalViewController()
                }
                navigationController?.pushViewController(legalViewController!, animated: true)
            case 1:
                if aboutViewController == nil {
                    aboutViewController = SettingsAboutViewController()
                }
                navigationController?.pushViewController(aboutViewController!, animated: true)
            default:
                ()
            }

        case 2:
            switch indexPath.row {
            case 0:
                if UIApplication.sharedApplication().canOpenURL(facebookAppURL) {
                    UIApplication.sharedApplication().openURL(facebookAppURL)
                } else {
                    UIApplication.sharedApplication().openURL(facebookWebURL)
                }
            case 1:
                if UIApplication.sharedApplication().canOpenURL(twitterAppURL) {
                    UIApplication.sharedApplication().openURL(twitterAppURL)
                } else {
                    UIApplication.sharedApplication().openURL(twitterWebURL)
                }
            default:
                ()
            }
        default:
            ()
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return 64.0
            case 1:
                return 80.0
            default:
                ()
            }
        }
        return 50.0
    }
}
