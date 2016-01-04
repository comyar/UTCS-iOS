@objc class ContentViewController: UIViewController {
    var menuButton = UIBarButtonItem.menuButton()
    var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    var backgroundImageName: String {
        willSet(newValue){
            backgroundImageView.image = UIImage(named: newValue)
        }
    }

    var dataSource: DataSource?

    convenience init(){
        self.init(nibName: nil, bundle: nil)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        backgroundImageName = ""
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configureViews()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureOnLoad()

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureOnLayout()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        configureOnAppear()
    }
    func configureViews() {
        title = ""
    }
    func configureOnLoad() {
        // Ensure that we get the fullscreen. This is important so that we don't get a 20px
        // offset when the status bar becomes visible.
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = .None
        view.addSubview(backgroundImageView)
    }
    func configureOnLayout() {
        backgroundImageView.frame = view.bounds
        view.sendSubviewToBack(backgroundImageView)
    }
    func configureOnAppear() {
    }
}
