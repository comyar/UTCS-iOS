import Foundation
import UIKit

let VerticalMenuDisplayNotification = "menuDisplay"

class VerticalMenuViewController: UIViewController, UIGestureRecognizerDelegate {
    private var tapRecognizer: UITapGestureRecognizer!
    
    private var showHideMenuDuration = 0.5

    var showingMenu = false
    var menuViewController: MenuViewController! {
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

    init(menuViewController: MenuViewController, contentViewController: UIViewController) {
        defer {
            self.menuViewController = menuViewController
            self.contentViewController = contentViewController
        }
        super.init(nibName: nil, bundle: nil)
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didRecognizeTap(_:)))
        tapRecognizer.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didReceiveMenuDisplayNotification), name:"menuDisplay", object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK:- Gestures

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

    // MARK:- Menu Display

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

        let targetY = menuViewController.bottomExtent + contentController.view.center.y
        self.showingMenu = true
        
        UIView.animateWithDuration(showHideMenuDuration, delay: 0, options: .CurveEaseInOut, animations: {
            contentController.view.center = CGPoint(x: self.view.center.x, y: targetY)
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }

    func hideMenu() {
        guard let contentController = contentViewController else {
            return
        }

        let targetY = contentController.view.center.y - menuViewController.bottomExtent
        self.showingMenu = false
        
        UIView.animateWithDuration(showHideMenuDuration, delay: 0, options: .CurveEaseInOut, animations: {
            contentController.view.center = CGPoint(x: self.view.center.x, y: targetY)
            self.setNeedsStatusBarAppearanceUpdate()
            }, completion: nil)
    }

    // MARK:- Status Bar
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
