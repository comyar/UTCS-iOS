import UIKit
import Foundation

class NewsArticleViewController: ArticleViewController {
    private static let minHeaderImageWidth: CGFloat = 300.0
    private static let minHeaderImageHeight: CGFloat = 250.0
    private var newsArticle: NewsArticle?

    init() {
       super.init(nibName: "ArticleView", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func configureWithNewsArticle(article: NewsArticle) {
        guard self.newsArticle != article else {
            return
        }
        scrollView.contentOffset = CGPointZero
        newsArticle = article

        if let articleImage = article.headerImage {
            configureImageHeightConstraint(articleImage)
            imageView.image = articleImage
        } else {
            let randomIndex = Int(arc4random_uniform(UInt32(ArticleViewController.defaultHeaderIdentifiers.count)))
            let image = UIImage(named: NewsArticleViewController.defaultHeaderIdentifiers[randomIndex])
            imageView.image = image
        }
        contentTextView.attributedText = article.attributedContent

        dateLabel.text = NSDateFormatter.localizedStringFromDate(article.date, dateStyle: .LongStyle, timeStyle: .NoStyle)
        titleLabel.text = article.title
        titleLabel.sizeToFit()

        if let title = newsArticle?.title {
            activityItems.append( title + "\n")
        }
        if let url = newsArticle?.url {
            activityItems.append(url.description)
        }
    }

    func selectHeaderImageForArticle(article: NewsArticle) {
        var tasks = [NSURLSessionDataTask]()
        for url in article.imageURLs! {
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url){ (data, response, error) -> Void in
                if let data = data,
                   let image = UIImage(data: data)
                    where image.size.width >= NewsArticleViewController.minHeaderImageWidth &&
                        image.size.height >= NewsArticleViewController.minHeaderImageHeight {
                            for task in tasks {
                                task.cancel()
                            }
                            article.headerImage = image
                    }

                }
            task.resume()
            tasks.append(task)
        }
    }

}
