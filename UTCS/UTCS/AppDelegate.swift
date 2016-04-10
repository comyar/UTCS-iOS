import UIKit
import Foundation
import MBProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MenuViewControllerDelegate {

    var controllers = [MenuOption : NavigationController]()
    var menuViewController = MenuViewController(nibName: nil, bundle: nil)
    var verticalMenuViewController: VerticalMenuViewController?
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Menu
        menuViewController.delegate = self
        controllers[.News] = NavigationController(rootViewController: NewsViewController())
        verticalMenuViewController = VerticalMenuViewController(menuViewController: menuViewController, contentViewController: controllers[.News]!)
        // Initialize view controllers. News is the default service

        window = UIWindow()
        window?.rootViewController = verticalMenuViewController
        window?.makeKeyAndVisible()
        configureAppearance()
        return true
    }

    func applicationWillTerminate(application: UIApplication) {
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    func configureAppearance() {
        let appearance = UINavigationBar.appearanceWhenContainedInInstancesOfClasses([NavigationController.Type]())
        appearance.tintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        appearance.translucent = true
        appearance.shadowImage = UIImage()
        appearance.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        appearance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        UITableViewCell.appearance().backgroundColor = .clearColor()

        UISegmentedControl.appearance().tintColor = .whiteColor()
        UISwitch.appearance().onTintColor = .utcsBurntOrangeColor()
    }

    func menuOptionWillBeSelected(option: MenuOption) -> Bool {
        if option == .Labs && !AuthenticationManager.authenticated {
            AuthenticationManager.presentAuthenticationAlert(menuViewController,
                reason:  "You must log into your CS account to view lab status information.") { error -> () in
                guard error == nil else {
                    AuthenticationManager.presentErrorAlert(self.menuViewController)
                    return
                }

                if AuthenticationManager.authenticated {
                    self.menuViewController.setSelection(.Labs, selected: true)
                } else {
                    self.menuViewController.setSelection(.Labs, selected: false)
                }
                MBProgressHUD.hideHUDForView(self.verticalMenuViewController!.view, animated: true)
                
            }
            
            return false
        }
        return true
    }
    
    func didSelectMenuOption(option: MenuOption) {
        if controllers[option] == nil {
            controllers[option] = {
                switch option {
                case .News:
                    return NavigationController(rootViewController: NewsViewController())
                case .Events:
                    return NavigationController(rootViewController: EventsViewController())
                case .Labs:
                    return NavigationController(rootViewController: LabsViewController())
                case .Directory:
                    let controller = NavigationController(rootViewController: DirectoryViewController())
                    controller.backgroundImageName = "Directory"
                    return controller
                case .DiskQuota:
                    return NavigationController(rootViewController: DiskQuotaViewController(nibName: "DiskQuotaView", bundle: NSBundle.mainBundle() ))
                case .Settings:
                    let controller = NavigationController(rootViewController: UIStoryboard(name: "Settings", bundle: NSBundle.mainBundle()).instantiateInitialViewController()!)
                    controller.backgroundImageName = "Settings"
                    return controller
                }
                }()
        }
        verticalMenuViewController?.contentViewController = controllers[option]!
    }

}
