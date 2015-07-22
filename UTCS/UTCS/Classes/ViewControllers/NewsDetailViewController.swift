
// Font size of the title label
let titleLabelFontSize: CGFloat = 28.0

// Font size of the date label
let dateLabelFontSize: CGFloat = 16.0

// Name of the share icon image
let shareImageName = "share"
class NewsDetailViewController: UIViewController {
    // YES if the view controller has initialized the subviews
    var hasInitializedSubviews = false

    // Label used to display the title of a news story
    var titleLabel: UILabel!

    // Label used to display the date of a news story
    var dateLabel: UILabel!

    // Text view used to display the news story
    var contentTextView: UITextView!

    var parallaxBlurHeaderScrollView: ParallaxBlurHeaderScrollView!
    var defaultHeaderImages: [String]!
    var scrollToTopButton: UIButton!
    var newsArticle: UTCSNewsArticle? {
        willSet(newValue){
            if newValue == newsArticle {
                return
            }
            if !hasInitializedSubviews {
                initializeSubviews()
                hasInitializedSubviews = true
            }
            configureWithNewsArticle(newValue!)
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        view.backgroundColor = UIColor.whiteColor()
        automaticallyAdjustsScrollViewInsets = false
        defaultHeaderImages = ["gdc-speedway"]
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initializeSubviews(){
        parallaxBlurHeaderScrollView = ParallaxBlurHeaderScrollView(frame: view.bounds)
        view.addSubview(parallaxBlurHeaderScrollView)
        scrollToTopButton = {
            let button = UIButton(type: .Custom)
            button.addTarget(self, action: "didTouchUpInsideButton:", forControlEvents: .TouchUpInside)
            button.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 44.0)
            navigationItem.titleView = button
            return button
        }()


        let button = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareArticle:")
        navigationItem.rightBarButtonItem = button

        titleLabel = {
            let label = UILabel(frame: CGRect(x: 8.0, y: kUTCSParallaxBlurHeaderHeight, width: view.frame.width - 16.0, height: 0.0))
            label.shadowColor = UIColor(white: 0.0, alpha: 0.5)
            label.shadowOffset = CGSize(width: 0.0, height: 0.5)
            label.textColor = UIColor.whiteColor()
            label.adjustsFontSizeToFitWidth = true
            label.numberOfLines = 0
            return label
        }()
        parallaxBlurHeaderScrollView.headerContainerView.addSubview(titleLabel)
        dateLabel = {
            let label = UILabel(frame: CGRect(x: 8.0, y: 0.0, width: view.frame.width - 16.0, height: 1.5 * dateLabelFontSize))
            label.font = UIFont.systemFontOfSize(dateLabelFontSize)
            label.textColor = UIColor(white: 1.0, alpha: 0.75)
            label.adjustsFontSizeToFitWidth = true
            return label
        }()
        parallaxBlurHeaderScrollView.headerContainerView.addSubview(dateLabel)
        contentTextView = {
            let textView = UITextView(frame: parallaxBlurHeaderScrollView.scrollView.bounds)
            textView.dataDetectorTypes = [.Link, .PhoneNumber, .Address]
            textView.textContainerInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
            textView.textColor = UIColor.utcsGrayColor()
            textView.scrollEnabled = false
            textView.editable = false
            return textView
        }()
        parallaxBlurHeaderScrollView.scrollView.addSubview(contentTextView)

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        parallaxBlurHeaderScrollView.scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
    }
    func configureWithNewsArticle(article: UTCSNewsArticle){
        parallaxBlurHeaderScrollView.scrollView.contentOffset = CGPointZero
        if article.headerImage != nil {
            parallaxBlurHeaderScrollView.headerImage = article.headerImage
        } else {
            parallaxBlurHeaderScrollView.headerImage = UIImage(named: defaultHeaderImages[0])
        }
        contentTextView.attributedText = article.attributedContent
        var contentTextViewHeight = contentTextView.sizeThatFits(CGSize(width: contentTextView.textContainer.size.width, height: CGFloat.max)).height
        contentTextViewHeight += contentTextView.textContainerInset.top + contentTextView.textContainerInset.bottom
        contentTextView.frame.size = CGSize(width: contentTextView.frame.width, height: max(contentTextViewHeight, 150.0))
        contentTextView.frame.origin = CGPoint(x: contentTextView.frame.origin.x, y: parallaxBlurHeaderScrollView.headerContainerView.frame.height)
        dateLabel.text = NSDateFormatter.localizedStringFromDate(article.date, dateStyle: .LongStyle, timeStyle: .NoStyle)
        dateLabel.frame.origin = CGPoint(x: dateLabel.frame.origin.x, y: parallaxBlurHeaderScrollView.headerContainerView.frame.height - dateLabel.frame.height - 8.0)
        titleLabel.frame = CGRect(x: 8.0, y: kUTCSParallaxBlurNavigationBarHeight, width: view.frame.width - 16.0, height: 0.0)
        titleLabel.text = article.title
        titleLabel.sizeToFit()
        if titleLabel.frame.height > kUTCSParallaxBlurHeaderHeight - kUTCSParallaxBlurNavigationBarHeight - dateLabel.frame.height {
            titleLabel.frame.size = CGSize(width: titleLabel.frame.width, height: kUTCSParallaxBlurHeaderHeight - kUTCSParallaxBlurNavigationBarHeight - dateLabel.frame.height)
        }
        titleLabel.frame.origin = CGPoint(x: titleLabel.frame.origin.x, y: parallaxBlurHeaderScrollView.headerContainerView.frame.height - (parallaxBlurHeaderScrollView.headerContainerView.frame.height - dateLabel.frame.origin.y) - titleLabel.frame.height)
        parallaxBlurHeaderScrollView.scrollView.contentSize = CGSize(width: parallaxBlurHeaderScrollView.frame.width, height: contentTextView.frame.height + parallaxBlurHeaderScrollView.headerContainerView.frame.height)
    }
    func didTouchUpInsideButton(button: UIButton){
        if button == scrollToTopButton {
            parallaxBlurHeaderScrollView.scrollView.scrollRectToVisible(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0), animated: true)
        }
    }
    func shareArticle(sender: UIBarButtonItem){
        var activityItems = [String]()
        if let title = newsArticle?.title {
            activityItems.append( title + "\n")
        }
        if let url = newsArticle?.url {
            activityItems.append(url)
        }
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypeAssignToContact, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypeSaveToCameraRoll]
        presentViewController(activityViewController, animated: true, completion: nil)
    }
}