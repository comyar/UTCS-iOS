import MBProgressHUD

class LabsViewController: ContentViewController, UIScrollViewDelegate, DataSourceDelegate {
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var refreshButton: UIButton!
    var basementLabViewController: UTCSLabMachineViewController!
    var thirdFloorLabViewController: UTCSLabMachineViewController!
    var labsDataSource: LabsDataSource! {
        get{
            return dataSource as! LabsDataSource!
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        dataSource = LabsDataSource()
        dataSource!.delegate = self
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = menuButton

        scrollView = {
            let scrollView = UIScrollView(frame: view.bounds)
            scrollView.contentSize = CGSize(width: 2.0 * view.frame.width, height: view.frame.height)
            scrollView.backgroundColor = UIColor.blackColor()
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.pagingEnabled = true
            scrollView.delegate = self
            return scrollView
        }()
        view.addSubview(scrollView)
        let thirdLayout = UTCSLabViewLayout(filename: "ThirdFloorLabLayout")
        thirdFloorLabViewController = UTCSLabMachineViewController(layout: thirdLayout)
        thirdFloorLabViewController.backgroundImageView.image = UIImage(named: "Third Floor Lab")

        thirdFloorLabViewController.view.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: view.frame.height)
        scrollView.addSubview(thirdFloorLabViewController.view)
        addChildViewController(thirdFloorLabViewController)
        thirdFloorLabViewController.didMoveToParentViewController(self)
        thirdFloorLabViewController.shimmeringView.frame = CGRect(x: 0.5 * view.frame.width, y: view.frame.height * 0.3, width: 0.4 * view.frame.width, height: 0.6 * view.frame.height)
        thirdFloorLabViewController.shimmeringView.contentView.frame = thirdFloorLabViewController.shimmeringView.bounds
        (thirdFloorLabViewController.shimmeringView.contentView as! UILabel).text = "Third Floor"

        let basementLayout = UTCSLabViewLayout(filename: "BasementLabLayout")
        basementLabViewController = UTCSLabMachineViewController(layout: basementLayout)

        basementLabViewController.backgroundImageView.image = UIImage(named: "Basement Lab")
        basementLabViewController.view.frame = CGRect(x: view.frame.width, y: 0.0, width: view.frame.width, height: view.frame.height)
        scrollView.addSubview(basementLabViewController.view)
        addChildViewController(basementLabViewController)
        basementLabViewController.didMoveToParentViewController(self)

        basementLabViewController.shimmeringView.frame = CGRect(x: 8.0, y: 0.72 * view.frame.height, width: view.frame.width - 16.0, height: 120.0)
        basementLabViewController.shimmeringView.contentView.frame = basementLabViewController.shimmeringView.bounds
        (basementLabViewController.shimmeringView.contentView as! UILabel).text = "Basement"

        pageControl = {
            let control = UIPageControl(frame: CGRect(x: 0.0, y: view.frame.height - 32.0, width: view.frame.width, height: 32.0))
            control.userInteractionEnabled = false
            control.numberOfPages = 2
            return control
        }()
        view.addSubview(pageControl)
        refreshButton = {
            let button = UIButton.bouncyButton()
            button.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
            button.center = CGPoint(x: view.frame.width - 33.0, y: 22.0)
            let image = UIImage(named: "refresh")?.imageWithRenderingMode(.AlwaysTemplate)
            let imageView = UIImageView(image: image)
            imageView.tintColor = UIColor.whiteColor()
            imageView.frame = button.bounds
            button.addSubview(imageView)
            button.addTarget(self, action: "didTouchUpInsideButton:", forControlEvents: .TouchUpInside)
            return button
        }()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if UTCSStateManager.sharedManager().preferredLab == 0 {
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        } else {
            scrollView.contentOffset = CGPoint(x: CGRectGetWidth(view.bounds), y: 0.0)
        }
        updateForced(false)
    }

    func updateForced(forced: Bool) {
        thirdFloorLabViewController.shimmeringView.shimmering = true
        basementLabViewController.shimmeringView.shimmering = true

        let hud = MBProgressHUD.showHUDAddedTo(scrollView, animated: true)
        hud.labelText = "Updating"
        hud.mode = .Indeterminate


        labsDataSource!.updateWithArgument(nil) { success, cachehit in
            self.thirdFloorLabViewController.shimmeringView.shimmering = false
            self.basementLabViewController.shimmeringView.shimmering = false

            if success {
                let third = self.labsDataSource!.data!["third"]
                let basement = self.labsDataSource!.data!["basement"]
                self.thirdFloorLabViewController.machines = third as! [NSObject: AnyObject]!
                self.basementLabViewController.machines = basement as! [NSObject: AnyObject]!
            }
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                let successValue: CGFloat = success ? 1.0 : 0.0
                self.thirdFloorLabViewController.shimmeringView.alpha = successValue
                self.basementLabViewController.shimmeringView.alpha = successValue
                self.thirdFloorLabViewController.serviceErrorView.alpha = 1.0 - successValue
                self.basementLabViewController.serviceErrorView.alpha = 1.0 - successValue
                self.thirdFloorLabViewController.labView.alpha  = successValue
                self.basementLabViewController.labView.alpha    = successValue
            })
            MBProgressHUD.hideAllHUDsForView(self.scrollView, animated: true)
        }
    }
    func didTouchUpInsideButton(button: UIButton) {
        if button == refreshButton {
            updateForced(true)
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageNumber = lround(max(0.0, Double(scrollView.contentOffset.x)) / Double(view.frame.width))
        pageControl.currentPage = pageNumber
        let thirdOffset = 0.5 * scrollView.contentOffset.x
        let basementOffset = 0.5 * (scrollView.contentOffset.x - view.frame.width)
        thirdFloorLabViewController.imageOffset = CGPoint(x: thirdOffset, y: 0.0)
        basementLabViewController.imageOffset = CGPoint(x: basementOffset, y: 0.0)
    }
}
