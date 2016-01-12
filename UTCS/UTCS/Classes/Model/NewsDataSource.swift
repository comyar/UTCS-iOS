import Alamofire
import SwiftyJSON

// News table view cell identifier.
let UTCSNewsTableViewCellIdentifier = "NewsCell"

final class NewsDataSource: ServiceDataSource, UITableViewDataSource {

    var articleData: [NewsArticle]? {
        return data as? [NewsArticle]
    }

    override var router: Router {
        return Router.News()
    }

    init() {
        super.init(service: .News, parser: NewsDataSourceParser())
        minimumTimeBetweenUpdates = 24 * 60 * 60
    }

    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let article = articleData?[indexPath.row],
        let cell = tableView.dequeueReusableCellWithIdentifier(UTCSNewsTableViewCellIdentifier, forIndexPath: indexPath) as? NewsTableViewCell else {
                return UITableViewCell()
        }

        cell.title!.text = article.title
        cell.detailLabel!.text = article.attributedContent.string
        return cell
    }

    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleData?.count ?? 0
    }


}
