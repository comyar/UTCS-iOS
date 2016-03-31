
import UIKit

class AboutViewController: AutomaticDimensionTableViewController {

    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var buildLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let application = UIApplication.sharedApplication()
        versionLabel.text = application.version
        buildLabel.text = application.build
    }
    
}
