import UIKit
import Foundation
import MBProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MenuViewControllerDelegate {

    var controllers = [MenuOption : NavigationController]()
    var menuViewController = MenuViewController(nibName: nil, bundle: nil)
    var verticalMenuViewController: UTCSVerticalMenuViewController?
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Menu
        menuViewController.delegate = self
        controllers[.News] = NavigationController(rootViewController: NewsViewController())
        verticalMenuViewController = UTCSVerticalMenuViewController(menuViewController: menuViewController, contentViewController: controllers[.News])
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
    }

    func didSelectMenuOption(option: MenuOption) {
        if option == .Labs && !AuthenticationManager.authenticated {
            AuthenticationManager.presentAuthenticationAlert(menuViewController, reason:  "You must log into your CS account to view lab status information.") { success, error -> () in
                if success {
                    if self.controllers[.Labs] == nil {
                        self.controllers[.Labs] = NavigationController(rootViewController: LabsViewController())
                    }
                    self.verticalMenuViewController?.contentViewController = self.controllers[.Labs]
                } else {
                    AuthenticationManager.presentErrorAlert(self.menuViewController)
                }
                MBProgressHUD.hideHUDForView(self.verticalMenuViewController!.view, animated: true)

            }

            return
        }
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
                    return NavigationController(rootViewController: DirectoryViewController())
                case .DiskQuota:
                    return NavigationController(rootViewController: DiskQuotaViewController(nibName: "DiskQuotaView", bundle: NSBundle.mainBundle() ))
                case .Settings:
                    return NavigationController(rootViewController: SettingsViewController())
                }
                }()
        }
        verticalMenuViewController?.contentViewController = controllers[option]
    }

}
