// Estimated height of table view cell
let estimatedCellHeight: CGFloat = 140.0

// Header title text
let headerTitleText = "UTCS News"

// Header subtitle text
let headerSubtitleText = "What Starts Here Changes the World"

// Name of the background image
let backgroundImageName = "newsBackground"

// Name of the blurred background image
let backgroundBlurredImageName = "newsBackground-blurred"

// View controller used to display a specific news story
var newsDetailViewController: NewsDetailViewController


class NewsViewController: HeaderTableViewController, UTCSDataSourceDelegate {

    init(style: UITableViewStyle) {
        super.init(style: style)
        tableView.dataSource = UTCSNewsDataSource(service: UTCSNewsServiceName)
        tableView.dataSource!.delegate = self
        backgroundImageView.image = UIImage.cacheless_imageNamed(backgroundImageName)

        activeHeaderView = NSBundle.mainBundle().loadNibNamed("ActiveHeaderView", owner: self, options: [:]) as! ActiveHeaderView
        activeHeaderView.sectionHeadLabel.text = headerTitleText
        activeHeaderView.subtitleLabel.text = headerSubtitleText

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
        tableView.dataSource?.updateWithArgument(nil){ success, cacheHit in
            activeHeaderView.showActiveAnimation(false)
            if tableView.dataSource?.data.count > 0 {
                let updateString = NSDateFormatter.localizedStringFromDate(tableView.dataSource.updated, dateStyle: .LongStyle, timeStyle: .MediumStyle)
                activeHeaderView.upatedLabel.text = "Updated \(updateString)"
            } else {
                if !success {
                    activeHeaderView.updatedLabel.text = "Please check your network connection."
                } else {
                    activeHeaderView.updatedLabel.text = "No articles available."
                }
            }
            if success && !cacheHit {
                tableView.reloadData()
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
        return [UTCSNewsDataSourceCacheKey: dataSource.data]
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return estimatedCellHeight
    }
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setHighlighted(true, animated: true)
    }
    func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setHighlighted(false, animated: true)
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let article = tableView.dataSource.data[indexPath.row]
        if newsDetailViewController == nil {
            newsDetailViewController = NewsDetailViewController()
        }
        newsDetailViewController.newsArticle = article
        navigationController?.pushViewController(newsDetailViewController, animated: true)
    }
}
