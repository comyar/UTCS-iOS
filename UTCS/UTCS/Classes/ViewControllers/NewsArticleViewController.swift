import UIKit
import Foundation

class NewsArticleViewController: ArticleViewController {

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

}
