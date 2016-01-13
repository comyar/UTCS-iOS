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
    }

    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let article = articleData?[indexPath.row],
        let cell = tableView.dequeueReusableCellWithIdentifier(UTCSNewsTableViewCellIdentifier, forIndexPath: indexPath) as? NewsTableViewCell else {
                return UITableViewCell()
        }

        cell.title!.text = article.title
        if let cellDescription = article.cleanedText {
            cell.detailLabel.text = cellDescription
        }
        return cell
    }

    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleData?.count ?? 0
    }


}
