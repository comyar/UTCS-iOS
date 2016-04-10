import UIKit

class NavigationController: UINavigationController {
    private let backgroundImageView = UIImageView()
    private let navigationDelegate = NavigationControllerDelegate()
    var backgroundImageName = "" {
        didSet(oldValue) {
            backgroundImageView.image = UIImage(named: backgroundImageName)
        }
    }
    override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: NavigationBar.self, toolbarClass: nil)
        backgroundImageView.backgroundColor = UIColor.blackColor()
        pushViewController(rootViewController, animated: false)
        view.addSubview(backgroundImageView)
        delegate = navigationDelegate
        navigationDelegate.navigationController = self
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundImageView.frame = view.bounds
        view.sendSubviewToBack(backgroundImageView)
    }

}
