import JVFloatLabeledTextField
import PocketSVG
import MBProgressHUD
import DPMeterView

class DiskQuotaViewController: ContentViewController, UITextFieldDelegate {
    // Button used to request disk quota information
    @IBOutlet var goButton: UIButton!

    // Label used to display the user's name
    @IBOutlet var nameLabel: UILabel!

    // Label used to display the updated time
    @IBOutlet var updatedLabel: UILabel!

    // Label used to display the usage percentage
    @IBOutlet var percentLabel: UILabel!

    //
    @IBOutlet var meterView: DPMeterView!

    //
    @IBOutlet var serviceErrorView: ServiceErrorView!

    // Label used to show more detailed disk quota information
    @IBOutlet var quotaDetailLabel: UILabel!

    // Label used to describe what disk quota is on first usage
    @IBOutlet var descriptionLabel: UILabel!

    // Textfield used to input the user's username
    @IBOutlet var usernameTextField: JVFloatLabeledTextField!

    var quotaDataSource: DiskQuotaDataSource {
        return dataSource as! DiskQuotaDataSource
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.dataSource = DiskQuotaDataSource(service: .DiskQuota, parser: DiskQuotaDataSourceParser())
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = menuButton


        view.backgroundColor = UIColor.blackColor()
        usernameTextField.floatingLabelTextColor = UIColor(white: 1.0, alpha: 0.5)
        usernameTextField.autocapitalizationType = .None;
        usernameTextField.floatingLabelActiveTextColor = UIColor.whiteColor()
        usernameTextField.autocorrectionType = .No;
        usernameTextField.textColor = UIColor.whiteColor()
        usernameTextField.tintColor = UIColor.whiteColor()
        usernameTextField.returnKeyType = .Go
        usernameTextField.delegate = self

        view.backgroundColor = UIColor.blackColor()
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "CS Username", attributes:
            [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.5)])

        goButton.layer.masksToBounds = true
        goButton.layer.cornerRadius = 4.0
        goButton.layer.borderWidth = 1.0
        goButton.layer.borderColor = UIColor.whiteColor().CGColor
        meterView.meterType = .LinearHorizontal
        meterView.setShape(PocketSVG.pathFromSVGFileNamed("cloud").takeUnretainedValue())
        meterView.trackTintColor = UIColor(white: 1.0, alpha: 0.2)

        updatedLabel.alpha = 0.0

        //serviceErrorView.errorLabel.text = "Ouch! Something went wrong.\n\nPlease check your CS username and network connection."
        backgroundImageName = "diskQuotaBackground"
    }

    @IBAction func didPressGo(sender: UIButton) {
        view.endEditing(true)
        if usernameTextField.text! != "" {
            update()
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        meterView.stopGravity()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        meterView.startGravity()
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        update()
        textField.resignFirstResponder()
        return true
    }

    func update(){
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.mode = .Indeterminate
        hud.labelText = "Fetching"
        quotaDataSource.updateWithArgument(usernameTextField.text!){ success, cacheHit in
            if success {
                self.nameLabel.text = self.quotaDataSource.quotaData.name
                let limit = self.quotaDataSource.quotaData.limit
                let usage = self.quotaDataSource.quotaData.usage
                let percentageUsage = usage / Double(limit)
                self.meterView.progressTintColor = UIColor.whiteColor()
                self.meterView.progress = CGFloat(percentageUsage)
                self.percentLabel.text = NSString(format: "%0.2f%%", 100 * percentageUsage) as String
                self.quotaDetailLabel.text = NSString(format: "%.0f / %.0f MB", usage, Double(limit)) as String
                self.updatedLabel.text = "Updated" + NSDateFormatter.localizedStringFromDate(self.dataSource!.updated!, dateStyle: .LongStyle, timeStyle: .MediumStyle)

            } else {
                self.updatedLabel.text = "Update failed"
            }
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                let success: CGFloat = success ? 1.0 : 0.0
                self.serviceErrorView.alpha = 1.0 - success;
                self.quotaDetailLabel.alpha = success - 0.3;
                self.percentLabel.alpha = success;
                self.meterView.alpha = success;
                self.nameLabel.alpha = success;
                self.descriptionLabel.alpha  = 0.0;
            })
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }

    }
}
