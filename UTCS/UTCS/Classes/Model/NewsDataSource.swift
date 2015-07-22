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

final class NewsDataSource: UTCSDataSource, UITableViewDataSource {
    
    override init!(service: String!) {
        super.init(service: service)
        parser = UTCSNewsDataSourceParser()
        primaryCacheKey = UTCSNewsDataSourceCacheKey
        cache = UTCSDataSourceCache(service: service)
        let testCache = cache.objectWithKey(UTCSNewsDataSourceCacheKey)
        let meta = testCache?[UTCSDataSourceCacheMetaDataName] as! UTCSDataSourceCacheMetaData?
        data = testCache?[UTCSDataSourceCacheValuesName]
        updated = meta?.timestamp
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(UTCSNewsTableViewCellIdentifier) as! NewsTableViewCell
        let article = data![indexPath.row]
        cell.title!.text = article.title
        cell.detailLabel!.text = article.attributedContent.description
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }

}