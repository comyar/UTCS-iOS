// Header title text
let headerTitleText = "UTCS News"

// Header subtitle text
let headerSubtitleText = "What Starts Here Changes the World"

// Name of the background image
let backgroundImageName = "newsBackground"



class NewsViewController: HeaderTableViewController, UTCSDataSourceDelegate {

    // View controller used to display a specific news story
    var newsDetailViewController: NewsDetailViewController?
    var newsDataSource: NewsDataSource! {
        get {
            return dataSource as! NewsDataSource!
        }
    }

    override init(style: UITableViewStyle) {
        super.init(style: style)
        dataSource = NewsDataSource(service: UTCSNewsServiceName)
        tableView.dataSource = newsDataSource
        backgroundImageView.image = UIImage.cacheless_imageNamed(backgroundImageName)

        activeHeaderView = NSBundle.mainBundle().loadNibNamed("ActiveHeaderView", owner: self, options: [:])[0] as! ActiveHeaderView
        activeHeaderView.sectionHeadLabel.text = headerTitleText
        activeHeaderView.subtitleLabel.text = headerSubtitleText

        tableView.registerNib(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: UTCSNewsTableViewCellIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        update()
    }
    override func didReceiveMemoryWarning() {
        newsDetailViewController = nil
    }

    func update(){
        activeHeaderView.showActiveAnimation(true)
        newsDataSource.updateWithArgument(nil){ success, cacheHit in
            self.activeHeaderView.showActiveAnimation(false)
            if self.newsDataSource.data!.count > 0 {
                let updateString = NSDateFormatter.localizedStringFromDate(self.newsDataSource.updated, dateStyle: .LongStyle, timeStyle: .MediumStyle)
                self.activeHeaderView.updatedLabel.text = "Updated \(updateString)"
            } else {
                if !success {
                    self.activeHeaderView.updatedLabel.text = "Please check your network connection."
                } else {
                    self.activeHeaderView.updatedLabel.text = "No articles available."
                }
            }
            if success && !cacheHit {
                self.tableView.reloadData()
            }
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.activeHeaderView.downArrowImageView.alpha = success ? 1.0 : 0.0
            })
        }
    }

    func objectsToCacheForDataSource(dataSource: UTCSDataSource!) -> [NSObject : AnyObject]! {
        if dataSource.data == nil {
            return nil
        }
        return [UTCSNewsDataSourceCacheKey: dataSource.data!]
    }
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setHighlighted(true, animated: true)
    }
    override func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setHighlighted(false, animated: true)
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let article = newsDataSource.data![indexPath.row] as! UTCSNewsArticle
        if newsDetailViewController == nil {
            newsDetailViewController = NewsDetailViewController()
        }
        newsDetailViewController!.newsArticle = article
        navigationController?.pushViewController(newsDetailViewController!, animated: true)
    }
}
