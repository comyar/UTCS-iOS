
// Modifier for the rate at which the background image view's alpha changes


class HeaderTableViewController: TableViewController {
    // Content offset property string used for KVO

    var activeHeaderView: ActiveHeaderView! {
        didSet(newValue) {
            activeHeaderView.frame = tableView.bounds
            tableView.tableHeaderView = activeHeaderView
        }
    }

    override init(style: UITableViewStyle) {
        super.init(style: style)
        tableView.addObserver(self, forKeyPath: contentOffsetPropertyString, options: .New, context: nil)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        tableView.tableHeaderView!.frame = tableView.bounds
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        if keyPath == contentOffsetPropertyString {
            let normalizedOffsetDelta = max(tableView.contentOffset.y / CGRectGetHeight(tableView.bounds), 0.0)
            //modify blur here
        }
    }

    deinit{
        tableView.removeObserver(self, forKeyPath: contentOffsetPropertyString)
    }
}
