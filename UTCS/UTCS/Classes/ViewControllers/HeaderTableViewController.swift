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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK:- Lifecycle

    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        // Ensure that the header is always the correct size
        let frame = tableView.bounds
        tableView.tableHeaderView?.frame = CGRect(x: frame.origin.x, y: frame.origin.y + 44.0, width: frame.width, height: frame.height - 44.0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.insertSubview(blurView, aboveSubview: backgroundImageView)
        activeHeaderView = NSBundle.mainBundle().loadNibNamed("ActiveHeaderView", owner: self, options: [:])[0] as! ActiveHeaderView

        activeHeaderView .configure()
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

    // MARK:- Scrolling

    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let headerHeight = tableView.tableHeaderView?.frame.height where
               targetContentOffset.memory.y < headerHeight else {
            return
        }
        let velocityThresholdMet = 3.0 > velocity.y && velocity.y > 0.3
        if  velocityThresholdMet {
            targetContentOffset.memory.y = headerHeight - 44.0
        }
        let reverseThresholdMet = -0.3 > velocity.y && velocity.y > -3.0
        if reverseThresholdMet {
            targetContentOffset.memory.y = -44.0
        }
    }

    // MARK:- KVO
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == contentOffsetPropertyString {
            guard blursBackground else {
                return
            }
            let windowHeight = UIScreen.mainScreen().bounds.height
            let normalizedOffsetDelta = min(tableView.contentOffset.y * 1.5, windowHeight) / windowHeight

            //If we aren't going to see a change, exit early
            if blurView.alpha == normalizedOffsetDelta {
                return
            }

            if let navBar = navigationController?.navigationBar as? NavigationBar {
                navBar.background.alpha = normalizedOffsetDelta
            }

            blurView.alpha = normalizedOffsetDelta
            tableView.tableHeaderView?.alpha = 1.0 - normalizedOffsetDelta
            customTitle.alpha = normalizedOffsetDelta
        } else if keyPath == "title" {
            customTitle.text = title
            activeHeaderView.titleLabel.text = title
        }
    }

    deinit {
        tableView.removeObserver(self, forKeyPath: contentOffsetPropertyString)
        removeObserver(self, forKeyPath: "title")
    }
}
