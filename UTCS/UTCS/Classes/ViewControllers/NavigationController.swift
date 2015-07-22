class NavigationController: UINavigationController {
    var navigationDelegate: NavigationControllerDelegate!
    var backgroundImageView: UIImageView?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        navigationDelegate = NavigationControllerDelegate()
        delegate = navigationDelegate
        navigationDelegate.navigationController = self
        backgroundImageView = UIImageView()
        view.addSubview(backgroundImageView!)
        view.sendSubviewToBack(backgroundImageView!)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundImageView?.frame = view.bounds
    }
}
