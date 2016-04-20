
import UIKit

class SettingsViewController: PhotoBackgroundTableViewController {
    
    @IBOutlet weak var preferredLabSegmentedControl: UISegmentedControl!

    @IBAction func setPreferredLab(sender: UISegmentedControl) {
        guard let lab = ComputerLab(rawValue: sender.selectedSegmentIndex) else { return }
        Preferences.preferredLab = lab
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        needsSectionHeaders = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        preferredLabSegmentedControl.selectedSegmentIndex = Preferences.preferredLab.rawValue
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        cell.setSelectedBackgroundColor(.utcsCellHighlight())
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard indexPath.section == 2 else { return }
        switch indexPath.row {
        case 0: openSocialLink(FACEBOOK_SOCIAL_LINK)
        case 1: openSocialLink(TWITTER_SOCIAL_LINK)
        default: ()
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
