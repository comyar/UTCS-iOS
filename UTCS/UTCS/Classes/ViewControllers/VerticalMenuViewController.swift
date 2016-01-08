import Foundation
import UIKit

let VerticalMenuDisplayNotification = "menuDisplay"

class VerticalMenuViewController: UIViewController, UIGestureRecognizerDelegate {
    private var tapRecognizer: UITapGestureRecognizer!
    private var contentAnimator: UIDynamicAnimator?
    private var contentItemBehavior: UIDynamicItemBehavior?
    private var contentSnapBehavior: UISnapBehavior?

    var menuViewController: UIViewController! {
        didSet(oldValue) {

            menuViewController.view.removeFromSuperview()
            menuViewController.removeFromParentViewController()

            menuViewController.view.frame = self.view.bounds
            view.addSubview(menuViewController.view)
            addChildViewController(menuViewController)
            menuViewController.didMoveToParentViewController(self)

            setNeedsStatusBarAppearanceUpdate()
        }
    }
    var contentViewController: UIViewController? {
        didSet(oldValue) {
            if oldValue == contentViewController {
                hideMenu()
                return
            }
            if let oldController = oldValue,
               let newController = contentViewController {
            oldController.view.removeGestureRecognizer(tapRecognizer)
            oldController.willMoveToParentViewController(nil)
            oldController.view.removeFromSuperview()
            oldController.removeFromParentViewController()

            newController.view.frame = oldController.view.frame
            addChildViewController(newController)
            view.addSubview(newController.view)
            newController.didMoveToParentViewController(self)
            configureContentViewController()
                hideMenu()

            } else if let newController = contentViewController {
                newController.view.frame = self.view.bounds
                addChildViewController(newController)
                view.addSubview(newController.view)
                newController.didMoveToParentViewController(self)
                configureContentViewController()
            }
        }
    }

    var showingMenu = false

    init(menuViewController: UIViewController, contentViewController: UIViewController) {
        defer {
            self.menuViewController = menuViewController
            self.contentViewController = contentViewController
        }
        super.init(nibName: nil, bundle: nil)
        tapRecognizer = UITapGestureRecognizer(target: self, action: "didRecognizeTap:")
        tapRecognizer.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveMenuDisplayNotification", name:"menuDisplay", object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func didRecognizeTap(recognizer: UITapGestureRecognizer) {
        if showingMenu {
            hideMenu()
        }
    }

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        guard gestureRecognizer == tapRecognizer else {
            return false
        }
        return showingMenu
    }

    func didReceiveMenuDisplayNotification() {
        if showingMenu {
            hideMenu()
        } else {
            showMenu()
        }
    }

    func showMenu() {
        guard let contentController = contentViewController else {
            return
        }
        if let animator = contentAnimator,
            let snapBehavior = contentSnapBehavior {
                animator.removeBehavior(snapBehavior)
        }

        let animator = UIDynamicAnimator(referenceView: view)
        let itemBehavior = UIDynamicItemBehavior(items: [contentController.view])
        itemBehavior.allowsRotation = false
        let oldFrame = contentController.navigationController?.navigationBar.frame
        let snapBehavior = UISnapBehavior(item: contentController.view, snapToPoint: CGPoint(x: view.center.x, y: view.frame.height))
        snapBehavior.damping = 0.15
        animator.addBehavior(itemBehavior)
        animator.addBehavior(snapBehavior)

        contentAnimator = animator
        contentItemBehavior = itemBehavior
        contentSnapBehavior = snapBehavior
        showingMenu = true
        // [self enableUserInteraction:NO forViewController:self.contentViewController]
        setNeedsStatusBarAppearanceUpdate()
        // Twiddle navigation bar
        /*
        [_contentViewController.navigationController.navigationBar setFrame: CGRectOffset(oldFrame, 50.0, 700.0)];
        _contentViewController.edgesForExtendedLayout = UIRectEdgeNone;
        [_contentViewController.navigationController.navigationBar setNeedsLayout ];
        _contentViewController.extendedLayoutIncludesOpaqueBars = YES;
        [_contentViewController.view layoutSubviews];
        */
    }

    func hideMenu() {
        guard let contentController = contentViewController,
               let animator = contentAnimator else {
            return
        }

        // These behaviors were attached to the last content controller
        if let snapBehavior = contentSnapBehavior,
           let contentBehavior = contentItemBehavior {
            animator.removeBehavior(contentBehavior)
            animator.removeBehavior(snapBehavior)
        }

        let snapBehavior = UISnapBehavior(item: contentController.view, snapToPoint: view.center)
        snapBehavior.damping = 0.15

        let itemBehavior = UIDynamicItemBehavior(items: [contentController.view])
        itemBehavior.allowsRotation = false

        animator.addBehavior(snapBehavior)
        animator.addBehavior(itemBehavior)
        contentSnapBehavior = snapBehavior
        contentItemBehavior = itemBehavior

        showingMenu = false
        //    [self enableUserInteraction:YES forViewController:self.contentViewController]
        setNeedsStatusBarAppearanceUpdate()
    }
    override func prefersStatusBarHidden() -> Bool {
        return !showingMenu
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    func enableUserInteraction(enabled: Bool, forViewController viewController: UIViewController) {
        if viewController is UINavigationController {
            for childViewController in viewController.childViewControllers {
                for subview in childViewController.view.subviews {
                    if subview.tag < NSIntegerMax {
                        subview.userInteractionEnabled = enabled
                    }
                }
            }
        } else {
            for subview in viewController.view.subviews {
                if (subview.tag < NSIntegerMax) {
                    subview.userInteractionEnabled = enabled
                }
            }
        }
    }

    func configureContentViewController() {
        contentViewController?.view.addGestureRecognizer(tapRecognizer)
        setNeedsStatusBarAppearanceUpdate()
    }
}
