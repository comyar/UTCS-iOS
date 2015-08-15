import Alamofire
import SwiftyJSON
// Name of the news service.
let UTCSNewsServiceName = "news"

// News table view cell identifier.
let UTCSNewsTableViewCellIdentifier = "NewsCell"

// Name of the image to use for a table view cell's accessory view.
let cellAccessoryImageName = "rightArrow"

// Minimum time between updates
let minimumTimeBetweenUpdates  = 86400.0  // 24 hours

final class NewsDataSource: DataSource, UITableViewDataSource {

    var articleData: [UTCSNewsArticle] {
        get {
            return data as! [UTCSNewsArticle]
        }
    }

    override var router: Router {
        get {
            return Router.News()
        }
    }

    init() {
        super.init(service: .News, parser: NewsDataSourceParser())
    }

    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(UTCSNewsTableViewCellIdentifier) as! NewsTableViewCell
        let article = data![indexPath.row]
        cell.title!.text = article.title
        cell.detailLabel!.text = article.attributedContent.description
        return cell
    }

    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }


}