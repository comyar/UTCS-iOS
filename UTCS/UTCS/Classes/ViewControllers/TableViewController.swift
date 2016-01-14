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
                navigationController?.navigationBar.backgroundColor = UIColor(white: 1.0, alpha: 0.4)
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
    var dataSource: ServiceDataSource?

    var showsNavigationBarSeparatorLine = true
    var needsSectionHeaders = false {
        didSet(oldValue) {
            tableView.reloadData()
        }
    }

    // MARK:- Initialization

    convenience init() {
        self.init(style: .Plain)
    }

    override init(style: UITableViewStyle) {
        backgroundImageName = "defaultBackground"
        super.init(style: style)

        navigationBarBackgroundVisible = false
        extendedLayoutIncludesOpaqueBars = true
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
        tableView.addLayoutGuide(tableView.readableContentGuide)
        tableView.cellLayoutMarginsFollowReadableWidth = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundImageView.frame = view.bounds

        view.sendSubviewToBack(backgroundImageView)
    }

    // MARK:- UITableViewController

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard needsSectionHeaders else {
            return nil
        }
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width - 8.0, height: 24.0))
        label.font = UIFont.systemFontOfSize(16.0)
        // Hack to get left margin
        label.text = "     " + (tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: section) ?? "")
        label.textColor = UIColor(white: 1.0, alpha: 1.0)
        label.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        return label
    }

    //Required for viewForHeaderInSection to be called
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return needsSectionHeaders ? 24.0 : 0.0
    }

}
