import UIKit
import Foundation

final class NewsViewController: HeaderTableViewController {

    static let headerSubtitleText = "What Starts Here Changes the World"

    let newsDetailViewController = NewsArticleViewController()
    var newsDataSource: NewsDataSource! {
        return dataSource as! NewsDataSource!
    }

    init() {
        super.init(style: .Plain)
        dataSource = NewsDataSource()
        tableView.dataSource = newsDataSource
        backgroundImageName = "News"
        title = "News"

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
        activeHeaderView.startActiveAnimation()
        newsDataSource.updateWithArgument(nil) { result in
            self.activeHeaderView.endActiveAnimation(result.successful)
            if self.newsDataSource.articleData?.count ?? 0 > 0 {
                self.lastUpdated = self.newsDataSource.updated!
            } else {
                if !result.successful {
                    self.activeHeaderView.updatedLabel.text = "Please check your network connection."
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        self.activeHeaderView.downArrowImageView.alpha = 0.0
                    })
                } else {
                    self.activeHeaderView.updatedLabel.text = "No articles available."
                }
            }
            self.tableView.reloadData()
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        guard let article = newsDataSource.articleData?[indexPath.row] else {
            return
        }
        newsDetailViewController.configureWithNewsArticle(article)
        navigationController?.pushViewController(newsDetailViewController, animated: true)
    }

}
