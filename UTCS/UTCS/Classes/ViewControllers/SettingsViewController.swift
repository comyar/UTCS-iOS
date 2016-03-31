
import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var eventNotificationsSwitch: UISwitch!
    
    @IBOutlet weak var preferredLabSegmentedControl: UISegmentedControl!
    
    @IBAction func receiveEventNotifications(sender: UISwitch) {
        Preferences.starredEventNotificationsEnabled = sender.on
    }
    
    @IBAction func setPreferredLab(sender: UISegmentedControl) {
        guard let lab = ComputerLab(rawValue: sender.selectedSegmentIndex) else { return }
        Preferences.preferredLab = lab
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        eventNotificationsSwitch.on = Preferences.starredEventNotificationsEnabled
        preferredLabSegmentedControl.selectedSegmentIndex = Preferences.preferredLab.rawValue
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard indexPath.section == 3 else { return }
        switch indexPath.row {
        case 0: openSocialLink(FACEBOOK_SOCIAL_LINK)
        case 1: openSocialLink(TWITTER_SOCIAL_LINK)
        default: ()
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
