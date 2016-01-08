
final class NewsViewController: HeaderTableViewController {

    static let headerTitleText = "UTCS News"
    static let headerSubtitleText = "What Starts Here Changes the World"

    let newsDetailViewController = NewsDetailViewController(nibName: nil, bundle: nil)
    var newsDataSource: NewsDataSource! {
        return dataSource as! NewsDataSource!
    }

    init() {
        super.init(style: .Plain)
        dataSource = NewsDataSource()
        tableView.dataSource = newsDataSource
        backgroundImageName = "News"
        title = "News"

        activeHeaderView.sectionHeadLabel.text = NewsViewController.headerTitleText
        activeHeaderView.subtitleLabel.text = NewsViewController.headerSubtitleText

        tableView.registerNib(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: UTCSNewsTableViewCellIdentifier)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    required convenience init?(coder: NSCoder) {
        self.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = menuButton
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        update()
    }

    func update() {
        activeHeaderView.showActiveAnimation(true)
        newsDataSource.updateWithArgument(nil) { success, cacheHit in
            self.activeHeaderView.showActiveAnimation(false)
            if self.newsDataSource.articleData?.count ?? 0 > 0 {
                self.lastUpdated = self.newsDataSource.updated!
            } else {
                if !success {
                    self.activeHeaderView.updatedLabel.text = "Please check your network connection."
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.activeHeaderView.downArrowImageView.alpha = 0.0
                    })
                } else {
                    self.activeHeaderView.updatedLabel.text = "No articles available."
                }
            }
            if success && !cacheHit {
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        guard let article = newsDataSource.articleData?[indexPath.row] else {
            return
        }
        newsDetailViewController.newsArticle = article
        navigationController?.pushViewController(newsDetailViewController, animated: true)
    }

}
