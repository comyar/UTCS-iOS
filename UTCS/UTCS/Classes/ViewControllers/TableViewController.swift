// Height of the navigation bar separator line
let navigationBarSeparatorLineHeight: CGFloat = 0.5

// Maximum alpha value of the navigation bar separator line view
let maximumNavigationBarSeparatorLineAlpha: CGFloat = 0.75


class TableViewController: UITableViewController, ContentController {
    var menuButton = UIBarButtonItem.menuButton()
    var blurView: UIVisualEffectView!
    var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    var backgroundImageName: String {
        willSet(newValue){
            backgroundImageView.image = UIImage(named: newValue)
        }
    }
    var dataSource: DataSource?
    // Button used to scroll table view to top.
    var gestureButton: UIButton!

    var showsNavigationBarSeparatorLine = true

    // View to represent the navigation bar separator line
    var navigationBarSeparatorLineView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.whiteColor()
        view.alpha = 0.0
        return view
    }()

    convenience init() {
        self.init(style: .Plain)
    }

    override init(style: UITableViewStyle) {
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        backgroundImageName = "defaultBackground"
        super.init(style: .Plain)
        commonInit()
    }

    func commonInit() {
        automaticallyAdjustsScrollViewInsets = false
        gestureButton = {
        let button = UIButton(type: .Custom)
        button.addTarget(self, action: "didTouchDownInsideButton", forControlEvents: .TouchDown)
        return button
        }()

        tableView.addObserver(self, forKeyPath: contentOffsetPropertyString, options: .New, context: nil)
        tableView.separatorColor = UIColor(white: 1.0, alpha: 0.05)
        tableView.backgroundColor = UIColor.clearColor()
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureOnLoad()
        view.insertSubview(navigationBarSeparatorLineView, aboveSubview: tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureOnLayout()
        let navbarHeight = navigationController?.navigationBar.bounds.height ?? 0
        let navigationBarHeight = max(navbarHeight, 44.0)
        navigationBarSeparatorLineView.frame = CGRect(x: 0.0, y: navigationBarHeight, width: view.bounds.width, height: navigationBarSeparatorLineHeight)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureOnAppear()
    }

    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        let navigationBarHeight = CGRectGetHeight(navigationController!.navigationBar.bounds)
        tableView.frame = CGRect(x: 0.0, y: navigationBarHeight, width: view.bounds.width, height: view.bounds.height - navigationBarHeight)
        gestureButton.frame = CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: navigationBarHeight)
        navigationBarSeparatorLineView.frame = CGRect(x: 0.0, y: navigationBarHeight, width: view.bounds.width, height: navigationBarSeparatorLineHeight)
        view.bringSubviewToFront(navigationBarSeparatorLineView)
    }

    func didTouchDownInsideButton(button: UIButton) {
        if button == gestureButton {
            tableView.scrollRectToVisible(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0), animated: true)
        }
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == contentOffsetPropertyString {
            let normalizedOffsetDelta = max(tableView.contentOffset.y / CGRectGetHeight(tableView.bounds), 0.0)
            navigationBarSeparatorLineView.alpha = showsNavigationBarSeparatorLine ? min(maximumNavigationBarSeparatorLineAlpha, normalizedOffsetDelta) : 0.0
        }
    }

    deinit {
        tableView.removeObserver(self, forKeyPath: contentOffsetPropertyString)
    }




    func configureViews() {
        title = ""
    }

    func configureOnLoad() {
        // Ensure that we get the fullscreen. This is important so that we don't get a 20px
        // offset when the status bar becomes visible.
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = .None
        view.addSubview(blurView)
        view.insertSubview(backgroundImageView, belowSubview: blurView)
    }

    func configureOnLayout() {
        blurView.frame = view.bounds
        backgroundImageView.frame = view.bounds
        view.sendSubviewToBack(blurView)
        view.sendSubviewToBack(backgroundImageView)
    }

    func configureOnAppear() {
    }
}
