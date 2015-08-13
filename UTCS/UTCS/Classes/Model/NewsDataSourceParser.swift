import SwiftyJSON

class NewsDataSourceParser: DataSourceParser {
    private static let titleKey = "title"
    private static let urlKey = "url"
    private static let dateKey = "date"
    private static let htmlKey = "noImgHtml"
    private static let imageUrlsKey = "imageUrls"
    private static let minHeaderImageWidth: CGFloat = 300.0
    private static let minHeaderImageHeight: CGFloat = 250.0

    override func parseValues(values: JSON) {
        var articles = [UTCSNewsArticle]()
        for articleData in values.array! {
            let article = UTCSNewsArticle()
            article.title = articleData[NewsDataSourceParser.titleKey].string
            article.url = articleData[NewsDataSourceParser.urlKey].URL
            article.html = articleData[NewsDataSourceParser.htmlKey].string
            article.imageURLs = [NSURL]()
            if let urls = articleData[NewsDataSourceParser.imageUrlsKey].array {
                for urlData in urls {
                    article.imageURLs.append(urlData.URL!)
                }
            }

            article.date = dateFormatter.dateFromString(articleData[NewsDataSourceParser.dateKey].string!)
            setHeaderImageForArticle(article)
        }
    }

    func setHeaderImageForArticle(article: UTCSNewsArticle){
        var headerFound = false
        for url in article.imageURLs {
            if headerFound {
                return
            }
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
                let request = NSURLRequest(URL: url as! NSURL)
                var response: NSURLResponse?
                var data: NSData?
                do {
                    data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
                }
                catch  {
                    print("header image request failed")
                }
                if data != nil {
                    var image = UIImage(data: data!)
                    if image!.size.width >= NewsDataSourceParser.minHeaderImageWidth && image!.size.height >= NewsDataSourceParser.minHeaderImageHeight {
                        image = UIImage.scaleImage(image, toSize: CGSize(width: 320.0, height: 284.0))
                        article.headerImage = image
                        headerFound = true
                    }
                }
            })
        }
    }
}