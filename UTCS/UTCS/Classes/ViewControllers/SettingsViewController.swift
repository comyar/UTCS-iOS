
import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var eventNotificationsSwitch: UISwitch!
    
    @IBOutlet weak var preferredLabSegmentedControl: UISegmentedControl!
    
    @IBAction func receiveEventNotifications(sender: UISwitch) {
        UTCSStateManager.sharedManager().eventNotifications = sender.on
    }
    
    @IBAction func setPreferredLab(sender: UISegmentedControl) {
        UTCSStateManager.sharedManager().preferredLab = sender.selectedSegmentIndex
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        eventNotificationsSwitch.on = UTCSStateManager.sharedManager().eventNotifications
        preferredLabSegmentedControl.selectedSegmentIndex = UTCSStateManager.sharedManager().preferredLab
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
