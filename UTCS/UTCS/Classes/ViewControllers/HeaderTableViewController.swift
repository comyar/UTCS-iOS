class HeaderTableViewController: TableViewController {

    var activeHeaderView: ActiveHeaderView! {
        didSet(oldValue) {
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
        // Ensure that the header is always the correct size
        tableView.tableHeaderView!.frame = tableView.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK:- KVO
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        if keyPath == contentOffsetPropertyString {
            let windowHeight = UIScreen.mainScreen().bounds.height
            let normalizedOffsetDelta = min(tableView.contentOffset.y * 1.5, windowHeight) / windowHeight

            //If we aren't going to see a change, exit early
            if blurView.alpha == normalizedOffsetDelta {
                return
            }
            blurView.alpha = normalizedOffsetDelta
            tableView.tableHeaderView?.alpha = 1.0 - normalizedOffsetDelta
        }
    }

    deinit{
        tableView.removeObserver(self, forKeyPath: contentOffsetPropertyString)
    }
}
