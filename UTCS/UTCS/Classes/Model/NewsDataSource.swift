import Alamofire

// Name of the news service.
let UTCSNewsServiceName = "news"

// Key used to cache news articles.
let UTCSNewsDataSourceCacheKey = "UTCSNewsDataSourceCacheKey"

// News table view cell identifier.
let UTCSNewsTableViewCellIdentifier = "NewsCell"

// Name of the image to use for a table view cell's accessory view.
let cellAccessoryImageName = "rightArrow"

// Minimum time between updates
let minimumTimeBetweenUpdates  = 86400.0  // 24 hours

final class NewsDataSource: DataSource, UITableViewDataSource {
    init() {
        super.init(service: .News, parser: UTCSNewsDataSourceParser())
        primaryCacheKey = UTCSNewsDataSourceCacheKey
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

    override func fetchData(completion: DataRequestCompletion) {
        Alamofire.request(Router.News()).responseJSON { (_, _, JSON) -> Void in
            completion(JSON.value!["meta"] as! [NSObject: AnyObject], JSON.value!["values"] as! [NSObject: AnyObject], nil)

        }
    }

}