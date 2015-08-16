import Alamofire
import SwiftyJSON

// News table view cell identifier.
let UTCSNewsTableViewCellIdentifier = "NewsCell"

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
        minimumTimeBetweenUpdates = 24 * 60 * 60
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