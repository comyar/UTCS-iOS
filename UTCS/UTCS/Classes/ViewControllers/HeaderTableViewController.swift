
// Modifier for the rate at which the background image view's alpha changes
let blurAlphaModifier: CGFloat = 2.0

// Content offset property string used for KVO
let contentOffsetPropertyString = "contentOffset";

class HeaderTableViewController: TableViewController {
    var activeHeaderView: ActiveHeaderView
    init () {
        super.init(style: .Plain)
    }
    init(style: UITableViewStyle) {
        super.init(style: style)
        tableView.addObserver(self, forKeyPath: contentOffsetPropertyString, options: .New, context: nil)

    }
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        tableView.tableHeaderView.frame = tableView.bounds
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

    func setActiveHeaderView(view: ActiveHeaderView){
        ActiveHeaderView = view
        activeHeaderView.frame = tableView.bounds
        tableView.tableHeaderView = activeHeaderView
    }

    deinit{
        tableView.removeObserver(self, forKeyPath: contentOffsetPropertyString)
    }
}
