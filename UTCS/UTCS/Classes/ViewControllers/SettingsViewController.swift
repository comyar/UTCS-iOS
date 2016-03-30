
import UIKit

enum SocialLink: String {
    
    case FacebookApp = "fb://page/272565539464226"
    case FacebookWeb = "https://fb.me/UTCompSci"
    case TwitterApp = "twitter://user?screen_name=utcompsci"
    case TwitterWeb = "https://twitter.com/UTCompSci"
    
}

extension NSURL {
    
    convenience init(_ link: SocialLink) {
        self.init(string: link.rawValue)!
    }
    
}

class SettingsViewController: TableViewController {

    var settingsDataSource: SettingsDataSource!
    var aboutViewController: AboutViewController?

    convenience init() {
        self.init(style: .Grouped)
    }

    override init(style: UITableViewStyle) {
        super.init(style: style)
        settingsDataSource = SettingsDataSource()
        tableView.dataSource = settingsDataSource
        title = "Settings"
        tableView.registerClass(SettingsTableViewCell.self, forCellReuseIdentifier: "settings")
        tableView.registerNib(UINib(nibName: "SegmentedControlTableViewCell", bundle: nil), forCellReuseIdentifier: "segmented")
        tableView.registerClass(SwitchTableViewCell.self, forCellReuseIdentifier: "switch")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = menuButton
    }

    override func didReceiveMemoryWarning() {
        aboutViewController = nil
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        guard let section = SettingsDataSource.Section(rawValue: indexPath.section) else {
            return
        }
        switch section {
        case .Info:
            if aboutViewController == nil {
                aboutViewController = AboutViewController()
            }
            navigationController?.pushViewController(aboutViewController!, animated: true)

        case .Social:
            switch indexPath.row {
            case 0:
                if UIApplication.sharedApplication().canOpenURL(NSURL(.FacebookApp)) {
                    UIApplication.sharedApplication().openURL(NSURL(.FacebookApp))
                } else {
                    UIApplication.sharedApplication().openURL(NSURL(.FacebookWeb))
                }
            case 1:
                if UIApplication.sharedApplication().canOpenURL(NSURL(.TwitterApp)) {
                    UIApplication.sharedApplication().openURL(NSURL(.TwitterApp))
                } else {
                    UIApplication.sharedApplication().openURL(NSURL(.TwitterWeb))
                }
            default:
                ()
            }
        default:
            ()
        }
    }

    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        guard let section = SettingsDataSource.Section(rawValue: indexPath.section) else {
            return false
        }
        return section == .Info || section == .Social
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
