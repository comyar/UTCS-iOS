import SwiftyJSON

class NewsDataSourceParser: DataSourceParser {
    private static let titleKey = "title"
    private static let urlKey = "url"
    private static let dateKey = "date"
    private static let htmlKey = "noImgHtml"
    private static let imageUrlsKey = "imageUrls"
    private static let minHeaderImageWidth: CGFloat = 300.0
    private static let minHeaderImageHeight: CGFloat = 250.0

    var parsedArticles: [NewsArticle] {
        return parsed as! [NewsArticle]
    }

    override func parseValues(values: JSON) {
        var articles = [NewsArticle]()
        for articleData in values.array! {
            let article = NewsArticle()
            article.title = articleData[NewsDataSourceParser.titleKey].string
            article.url = articleData[NewsDataSourceParser.urlKey].URL
            article.html = articleData[NewsDataSourceParser.htmlKey].string
            article.imageURLs = [NSURL]()
            if let urls = articleData[NewsDataSourceParser.imageUrlsKey].array {
                for urlData in urls {
                    article.imageURLs!.append(urlData.URL!)
                }
            }

            article.date = DataSourceParser.dateFormatter.dateFromString(articleData[NewsDataSourceParser.dateKey].string!)
            setHeaderImageForArticle(article)
            articles.append(article)

        }
        parsed = articles
    }

    func setHeaderImageForArticle(article: NewsArticle) {
        var tasks = [NSURLSessionDataTask]()
        for url in article.imageURLs! {
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                if let data = data {
                    var image = UIImage(data: data)!
                    if image.size.width >= NewsDataSourceParser.minHeaderImageWidth &&
                        image.size.height >= NewsDataSourceParser.minHeaderImageHeight {
                            for task in tasks {
                                task.cancel()
                            }
                            image = UIImage.scaleImage(image, toSize: CGSize(width: 320.0, height: 284.0))
                            article.headerImage = image
                    }

                }
            })
            task.resume()
            tasks.append(task)
        }
    }
}
