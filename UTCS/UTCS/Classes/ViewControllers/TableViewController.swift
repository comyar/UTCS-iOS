import UIKit

// Height of the navigation bar separator line
let navigationBarSeparatorLineHeight: CGFloat = 0.5

// Maximum alpha value of the navigation bar separator line view
let maximumNavigationBarSeparatorLineAlpha: CGFloat = 0.75


class TableViewController: UITableViewController {
    var menuButton = UIBarButtonItem.menuButton()

    var navigationBarBackgroundVisible = true {
        willSet(newValue) {
            if navigationBarBackgroundVisible {
                navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
            } else {
                navigationController?.navigationBar.backgroundColor = UIColor.redColor()
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
        willSet(newValue) {
            backgroundImageView.image = UIImage(named: newValue)
        }
    }
    var dataSource: DataSource?
    // Button used to scroll table view to top.
    var gestureButton: UIButton!

    var showsNavigationBarSeparatorLine = true
    var needsSectionHeaders = false {
        didSet(oldValue) {
            tableView.reloadData()
        }
    }

    // View to represent the navigation bar separator line
    var navigationBarSeparatorLineView: UIView = {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.whiteColor()
        view.alpha = 0.0
        return view
    }()

    // MARK:- Initialization

    convenience init() {
        self.init(style: .Plain)
    }

    override init(style: UITableViewStyle) {
        backgroundImageName = "defaultBackground"
        super.init(style: style)

        navigationBarBackgroundVisible = false
        tableView.addObserver(self, forKeyPath: contentOffsetPropertyString, options: .New, context: nil)
        tableView.separatorColor = UIColor(white: 1.0, alpha: 0.05)
        tableView.backgroundColor = UIColor.clearColor()
        tableView.sectionIndexColor = UIColor.whiteColor()
        tableView.sectionIndexBackgroundColor = UIColor.clearColor()
        tableView.tableHeaderView?.backgroundColor = UIColor.clearColor()
        tableView.cellLayoutMarginsFollowReadableWidth = true

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        view.insertSubview(navigationBarSeparatorLineView, aboveSubview: tableView)
        tableView.addLayoutGuide(tableView.readableContentGuide)
        tableView.cellLayoutMarginsFollowReadableWidth = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundImageView.frame = view.bounds

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

    // MARK:- UITableViewController

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard needsSectionHeaders else {
            return nil
        }
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width - 8.0, height: 24.0))
        label.font = UIFont.systemFontOfSize(16.0)
        label.text = textForHeaderInSection(section)
        label.textColor = UIColor(white: 1.0, alpha: 1.0)
        label.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return label
    }

    func textForHeaderInSection(section: Int) -> String {
        return ""
    }

    //Required for viewForHeaderInSection to be called
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return needsSectionHeaders ? 24.0 : 0.0
    }

    // MARK:- KVO
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String:AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == contentOffsetPropertyString {
            let normalizedOffsetDelta = max(tableView.contentOffset.y / tableView.bounds.height, 0.0)
            navigationBarSeparatorLineView.alpha = showsNavigationBarSeparatorLine ? min(maximumNavigationBarSeparatorLineAlpha, normalizedOffsetDelta) : 0.0
        }
    }

    deinit {
        tableView.removeObserver(self, forKeyPath: contentOffsetPropertyString)
    }

}
