// Height of the navigation bar separator line
let navigationBarSeparatorLineHeight: CGFloat = 0.5

// Maximum alpha value of the navigation bar separator line view
let maximumNavigationBarSeparatorLineAlpha: CGFloat = 0.75


class TableViewController: UITableViewController {
    var menuButton = UIBarButtonItem.menuButton()
    var blurView: UIVisualEffectView!
    var fullScreen = true {
        willSet(newValue){
            if fullScreen {
                automaticallyAdjustsScrollViewInsets = false
                extendedLayoutIncludesOpaqueBars = true
                edgesForExtendedLayout = .None
            } else {
                automaticallyAdjustsScrollViewInsets = false
                extendedLayoutIncludesOpaqueBars = false
                edgesForExtendedLayout = .None
            }
        }
    }
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
        fullScreen = true
        tableView.addObserver(self, forKeyPath: contentOffsetPropertyString, options: .New, context: nil)
        tableView.separatorColor = UIColor(white: 1.0, alpha: 0.05)
        tableView.backgroundColor = UIColor.clearColor()
        tableView.sectionIndexColor = UIColor.whiteColor()
        tableView.sectionIndexBackgroundColor = UIColor.clearColor()
        tableView.tableHeaderView?.backgroundColor = UIColor.clearColor()
        tableView.cellLayoutMarginsFollowReadableWidth = true
        title = ""
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(blurView)
        view.insertSubview(backgroundImageView, belowSubview: blurView)
        view.insertSubview(navigationBarSeparatorLineView, aboveSubview: tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        blurView.frame = view.bounds
        backgroundImageView.frame = view.bounds
        view.sendSubviewToBack(blurView)
        view.sendSubviewToBack(backgroundImageView)
        let navbarHeight = navigationController?.navigationBar.bounds.height ?? 0
        let navigationBarHeight = max(navbarHeight, 44.0)
        navigationBarSeparatorLineView.frame = CGRect(x: 0.0, y: navigationBarHeight, width: view.bounds.width, height: navigationBarSeparatorLineHeight)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        let navigationBarHeight = CGRectGetHeight(navigationController!.navigationBar.bounds)

        navigationBarSeparatorLineView.frame = CGRect(x: 0.0, y: navigationBarHeight, width: view.bounds.width, height: navigationBarSeparatorLineHeight)
        view.bringSubviewToFront(navigationBarSeparatorLineView)
    }

    // MARK:- KVO
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == contentOffsetPropertyString {
            let normalizedOffsetDelta = max(tableView.contentOffset.y / tableView.bounds.height, 0.0)
            navigationBarSeparatorLineView.alpha = showsNavigationBarSeparatorLine ? min(maximumNavigationBarSeparatorLineAlpha, normalizedOffsetDelta) : 0.0
        }
    }

    deinit {
        tableView.removeObserver(self, forKeyPath: contentOffsetPropertyString)
    }

}
