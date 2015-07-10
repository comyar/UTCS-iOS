class LabsViewController: ContentViewController, UIScrollViewDelegate, UTCSDataSourceDelegate {
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var refreshButton: UIButton!
    var basementLabViewController: UTCSLabMachineViewController!
    var thirdFloorLabViewController: UTCSLabMachineViewController!

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        dataSource = UTCSLabsDataSource(service: "labs")
        dataSource.delegate = self
    }
    override func viewDidLoad() {
        scrollView = {
            let scrollView = UIScrollView(frame: view.bounds)
            scrollView.contentSize = CGSize(width: 2.0 * view.width, height: view.height)
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
        thirdFloorLabViewController.backgroundImageView.image = UIImage.cacheless_imageNamed("thirdLabsBackground")

        thirdFloorLabViewController.view.frame = CGRect(x: 0.0, y: 0.0, width: view.width, height: view.height)
        scrollView.addSubview(thirdFloorLabViewController.view)
        addChildViewController(thirdFloorLabViewController)
        thirdFloorLabViewController.didMoveToParentViewController(self)
        thirdFloorLabViewController.shimmeringView.frame = CGRect(x: 0.5 * view.width, y: view.height * 0.3, width: 0.4 * view.width, height: 0.6 * view.height)
        thirdFloorLabViewController.shimmeringView.contentView.frame = thirdFloorLabViewController.shimmeringView.bounds
        (thirdFloorLabViewController.shimmeringView.contentView as! UILabel).text = "Third Floor"

        let basementLayout = UTCSLabViewLayout(filename: "BasementLabLayout")
        basementLabViewController = UTCSLabMachineViewController(layout: basementLayout)

        basementLabViewController.backgroundImageView.image = UIImage.cacheless_imageNamed("basementLabsBackground")
        basementLabViewController.view.frame = CGRect(x: view.width, y: 0.0, width: view.width, height: view.height)
        scrollView.addSubview(basementLabViewController.view)
        addChildViewController(basementLabViewController)
        basementLabViewController.didMoveToParentViewController(self)

        basementLabViewController.shimmeringView.frame = CGRect(x: 8.0, y: 0.72 * view.height, width: view.width - 16.0, height: 120.0)
        basementLabViewController.shimmeringView.contentView.frame = basementLabViewController.shimmeringView.bounds
        (basementLabViewController.shimmeringView.contentView as! UILabel).text = "Basement"

        pageControl = {
            let control = UIPageControl(frame: CGRect(x: 0.0, y: view.height - 32.0, width: view.width, height: 32.0))
            control.userInteractionEnabled = false
            control.numberOfPages = 2
            return control
        }()
        view.addSubview(pageControl)
        refreshButton = {
            let button = UIButton.bouncyButton()
            button.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
            button.center = CGPoint(x: view.width - 33.0, y: 22.0)
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
        if UTCSStateManager.sharedManager().preferredLab == 0   {
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        } else {
            scrollView.contentOffset = CGPoint(x: CGRectGetWidth(view.bounds), y: 0.0)
        }
        updateForced(false)
    }

    func updateForced(forced: Bool){
        thirdFloorLabViewController.shimmeringView.shimmering = true
        basementLabViewController.shimmeringView.shimmering = true

        if dataSource.shouldUpdate {
            let hud = MBProgressHUD.showHUDAddedTo(scrollView, animated: true)
            hud.labelText = "Updating"
            hud.mode = .Indeterminate
        }

        dataSource.updateWithArgument(nil){ success, cachehit in
            thirdFloorLabViewController.shimmeringView.shimmering = false
            basementLabViewController.shimmeringView.shimmering = false

            if success {
                let third = dataSource.data["third"]
                let basement = dataSource.data["basement"]
                thirdFloorLabViewController.machines = third
                basementLabViewController.machines = basement
            }
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                let successValue = success ? 1.0 : 0.0
                self.thirdFloorLabViewController.shimmeringView.alpha = successValue
                self.basementLabViewController.shimmeringView.alpha = successValue
                self.thirdFloorLabViewController.serviceErrorView.alpha = 1.0 - successValue
                self.basementLabViewController.serviceErrorView.alpha = 1.0 - successValue
                self.thirdFloorLabViewController.labView.alpha  = successValue
                self.basementLabViewController.labView.alpha    = successValue
            })
            MBProgressHUD.hideAllHUDsForView(scrollView, animated: true)
        }
    }
    func didTouchUpInsideButton(button: UIButton){
        if button == refreshButton {
            updateForced(true)
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageNumber = lround(max(0, scrollView.contentOffset.x)/view.width)
        pageControl.currentPage = pageNumber
        let thirdOffset = 0.5 * scrollView.contentOffset.x
        let basementOffset = 0.5 * (scrollView.contentOffset.x - view.width)
        thirdFloorLabViewController.imageOffset = CGPoint(x: thirdOffset, y: 0.0)
        basementLabViewController.imageOffset = CGPoint(x: basementOffset, y: 0.0)
    }

    func objectsToCacheForDataSource(dataSource: UTCSDataSource!) -> [NSObject : AnyObject]! {
        return [UTCSLabsDataSourceCacheKey: dataSource.data]
    }
}