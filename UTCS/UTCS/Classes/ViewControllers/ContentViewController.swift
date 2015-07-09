protocol ContentController {
    var menuButton: UIButton!
    var backgroundImageView:UIImageView!

    func configureViews()
    func configureOnLoad()
    func configureOnLayout()
    func configureOnAppear()
}

extension UIViewController: ContentController {
    var menuButton: UIButton!
    var backgroundImageView: UIImageView!

    func configureViews() {
        title = ""
        menuButton = UIButton.menuButton()
        backgroundImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .ScaleAspectFill
            imageView.clipsToBounds = true
            return imageView
        }()
    }
    func configureOnLoad(){
        view.addSubview(backgroundImageView)
        view.addSubview(menuButton)
    }
    func configureOnLayout(){
        backgroundImageView.frame = view.bounds
        menuButton.center = CGPoint(x: 33, y: 22)
        view.bringSubviewToFront(menuButton)
        view.sendSubviewToBack(backgroundImageView)
    }
    func configureOnAppear(){
        view.bringSubviewToFront(menuButton)
    }

}

@objc class ContentViewController: UIViewController, ContentController  {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configureViews()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
}
