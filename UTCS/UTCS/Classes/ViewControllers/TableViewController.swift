// Height of the navigation bar separator line
let navigationBarSeparatorLineHeight: CGFloat = 0.5

// Maximum alpha value of the navigation bar separator line view
let maximumNavigationBarSeparatorLineAlpha: CGFloat = 0.75


class TableViewController: UITableViewController, ContentController {
    var menuButton: UIButton = UIButton.menuButton()
    var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    var dataSource: DataSource?
    // Button used to scroll table view to top.
    var gestureButton: UIButton!

    var showsNavigationBarSeparatorLine = true

    // View to represent the navigation bar separator line (this should probably be a CAShapeLayer, #yolo).
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
        super.init(style: .Plain)
        commonInit()
    }
    func commonInit(){
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
        view.insertSubview(gestureButton, aboveSubview: menuButton)
        view.insertSubview(navigationBarSeparatorLineView, aboveSubview: tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureOnLayout()
        let navigationBarHeight = max(CGRectGetHeight(navigationController!.navigationBar.bounds), 44.0)
        //tableView.frame = CGRectMake(0.0, navigationBarHeight, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds) - navigationBarHeight)
        //gestureButton.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(view.bounds), navigationBarHeight)
        //navigationBarSeparatorLineView.frame = CGRectMake(0.0, navigationBarHeight, CGRectGetWidth(view.bounds), navigationBarSeparatorLineHeight)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureOnAppear()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        let navigationBarHeight = CGRectGetHeight(navigationController!.navigationBar.bounds)
        tableView.frame = CGRectMake(0.0, navigationBarHeight, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds) - navigationBarHeight)
        gestureButton.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(view.bounds), navigationBarHeight)
        view.insertSubview(gestureButton, belowSubview: menuButton)
        navigationBarSeparatorLineView.frame = CGRectMake(0.0, navigationBarHeight, CGRectGetWidth(view.bounds), navigationBarSeparatorLineHeight)
        view.bringSubviewToFront(navigationBarSeparatorLineView)
    }

    func didTouchDownInsideButton(button: UIButton){
        if button == gestureButton {
            tableView.scrollRectToVisible(CGRectMake(0.0, 0.0, 1.0, 1.0), animated: true)
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

    func setBackgroundImageName(name: String) {
        backgroundImageView.image = UIImage(named: name)?.imageWithRenderingMode(.AlwaysTemplate)
    }

    func configureViews() {
        title = ""
    }

    func configureOnLoad(){
        view.addSubview(backgroundImageView)
        view.addSubview(menuButton)
    }
    
    func configureOnLayout(){
        backgroundImageView.frame = view.bounds
        menuButton.center = CGPoint(x: 33, y: 22)
        view.bringSubviewToFront(menuButton)
        view.sendSubviewToBack(backgroundImageView)
    }
    
    func configureOnAppear(){
        view.bringSubviewToFront(menuButton)
    }
}
