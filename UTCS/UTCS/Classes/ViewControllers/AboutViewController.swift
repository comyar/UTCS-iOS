import UIKit

class AboutViewController: PhotoBackgroundTableViewController {
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var buildLabel: UILabel!
    let MAD_LINK = NSURL(string: "https://www.cs.utexas.edu/users/mad/")!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let application = UIApplication.sharedApplication()
        versionLabel.text = application.version
        buildLabel.text = application.build
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard indexPath.section == 0 && indexPath.row == 1 else { return }
        UIApplication.sharedApplication().openURL(MAD_LINK)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
