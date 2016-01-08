class HeaderTableViewController: TableViewController {
    private let customTitle = UILabel()
    var blursBackground = true
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
    var activeHeaderView: ActiveHeaderView! {
        didSet(oldValue) {
            activeHeaderView.frame = tableView.bounds
            tableView.tableHeaderView = activeHeaderView
        }
    }

    var lastUpdated: NSDate? {
        didSet(oldValue) {
            guard let updated = lastUpdated else {
                return
            }
            let updateString = NSDateFormatter.localizedStringFromDate(updated, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
            self.activeHeaderView.updatedLabel.text = "Updated \(updateString)"
        }
    }

    // MARK:- Initialization

    override init(style: UITableViewStyle) {
        super.init(style: style)
        tableView.addObserver(self, forKeyPath: contentOffsetPropertyString, options: .New, context: nil)
        self.addObserver(self, forKeyPath: "title", options: .New, context: nil)
        // Shift the tableview under the navbar
        tableView.contentInset = UIEdgeInsets(top: -44.0, left: 0.0, bottom: 0.0, right: 0.0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK:- Lifecycle

    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        // Ensure that the header is always the correct size
        tableView.tableHeaderView?.frame = tableView.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.insertSubview(blurView, aboveSubview: backgroundImageView)
        activeHeaderView = NSBundle.mainBundle().loadNibNamed("ActiveHeaderView", owner: self, options: [:])[0] as! ActiveHeaderView
        customTitle.text = title
        customTitle.font = UIFont.systemFontOfSize(18.0, weight: UIFontWeightMedium)
        customTitle.textColor = UIColor.whiteColor()
        customTitle.frame = CGRect(x: 100.0, y: 100.0, width: 30.0, height: 50.0)
        navigationItem.titleView = customTitle
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        blurView.frame = view.bounds
        view.sendSubviewToBack(blurView)
        view.sendSubviewToBack(backgroundImageView)

    }

    // MARK:- KVO
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == contentOffsetPropertyString {
            let windowHeight = UIScreen.mainScreen().bounds.height
            let normalizedOffsetDelta = min(tableView.contentOffset.y * 1.5, windowHeight) / windowHeight

            //If we aren't going to see a change, exit early
            if blurView.alpha == normalizedOffsetDelta {
                return
            }
            blurView.alpha = normalizedOffsetDelta
            tableView.tableHeaderView?.alpha = 1.0 - normalizedOffsetDelta

            customTitle.alpha = normalizedOffsetDelta
        } else if keyPath == "title" {
            customTitle.text = title
        }
    }

    deinit {
        tableView.removeObserver(self, forKeyPath: contentOffsetPropertyString)
        removeObserver(self, forKeyPath: "title")
    }
}
