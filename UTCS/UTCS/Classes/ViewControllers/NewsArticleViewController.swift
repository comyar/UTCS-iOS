import UIKit
import Foundation

class NewsArticleViewController: ArticleViewController {
    private static let minHeaderImageWidth: CGFloat = 300.0
    private static let minHeaderImageHeight: CGFloat = 250.0
    private var newsArticle: NewsArticle?

    private var images = [UIImage]()

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
        selectHeaderImageForArticle(article)
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

    func headerImageSelected(image: UIImage?) {
        let finalImage: UIImage
        if image == nil {
            let randomIndex = Int(arc4random_uniform(UInt32(ArticleViewController.defaultHeaderIdentifiers.count)))
            finalImage = UIImage(named: NewsArticleViewController.defaultHeaderIdentifiers[randomIndex])!

        } else {
            finalImage = image!
        }

        dispatch_async(dispatch_get_main_queue()) {
            self.configureImageHeightConstraint(finalImage)
            self.imageView.image = finalImage
        }
    }

    func selectHeaderImageForArticle(article: NewsArticle) {
        var tasks = [NSURLSessionDataTask]()
        var remaining = article.imageURLs.count
        if remaining == 0 {
            self.headerImageSelected(nil)
        }
        for url in article.imageURLs {
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url){ (data, response, error) -> Void in
                remaining -= 1
                if let data = data,
                   let image = UIImage(data: data)
                    where image.size.width >= NewsArticleViewController.minHeaderImageWidth &&
                        image.size.height >= NewsArticleViewController.minHeaderImageHeight {
                            tasks.forEach{$0.cancel()}
                            self.headerImageSelected(image)
                } else if remaining == 0 {
                    self.headerImageSelected(nil)
                }
            }
            task.resume()
            tasks.append(task)
        }
    }

}
