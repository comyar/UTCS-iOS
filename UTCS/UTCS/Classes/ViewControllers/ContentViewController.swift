@objc protocol ContentController {
    var menuButton: UIButton! { get set }
    var backgroundImageView: UIImageView! { get set }
    var dataSource: DataSource? { get set }
    func setBackgroundImageName(name: String)
    func configureViews()
    func configureOnLoad()
    func configureOnLayout()
    func configureOnAppear()
}

@objc class ContentViewController: UIViewController, ContentController  {
    var menuButton: UIButton = UIButton.menuButton()
    var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    var dataSource: DataSource?

    convenience init(){
        self.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
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

    func setBackgroundImageName(name: String) {
        backgroundImageView.image = UIImage.cacheless_imageNamed(name)
    }

    func configureViews() {
        title = ""
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
