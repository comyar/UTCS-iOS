import UIKit
import Foundation
import MBProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MenuViewControllerDelegate {

    var controllers = [MenuOption : NavigationController]()

    // Alert view used to authenticate the user (for any services that require authentication)
    var authenticationAlertView: UIAlertController?

    var menuViewController = MenuViewController(nibName: nil, bundle: nil)
    var verticalMenuViewController: UTCSVerticalMenuViewController?
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool  {
        // Menu
        menuViewController.delegate = self
        controllers[.News] = NavigationController(rootViewController: NewsViewController())
        verticalMenuViewController = UTCSVerticalMenuViewController(menuViewController: menuViewController, contentViewController: controllers[.News])
        // Initialize view controllers. News is the default service

        window = UIWindow()
        window?.rootViewController = verticalMenuViewController;
        window?.makeKeyAndVisible()
        configureAppearance()
        return true
    }
    func applicationDidBecomeActive(application: UIApplication) {
        UTCSStarredEventsManager.sharedManager().purgePastEvents()
    }
    func applicationWillTerminate(application: UIApplication) {
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    func configureAppearance(){
        let appearance = UINavigationBar.appearanceWhenContainedInInstancesOfClasses([NavigationController.Type]())
        appearance.tintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.grayColor()
        appearance.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        appearance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }

    func didSelectMenuOption(option: MenuOption){
        guard !(option == .Labs && UTCSAuthenticationManager.sharedManager().authenticated) else {
            prepareAuthenticationAlertView()
            authenticationAlertView?.message = "You must log into your CS account to view lab status information."
            verticalMenuViewController?.presentViewController(authenticationAlertView!, animated: true, completion: nil)
            return
        }
        if controllers[option] == nil {
            controllers[option] = {
                switch option{
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
    func prepareAuthenticationAlertView(){
        guard authenticationAlertView == nil else {
            return
        }
        authenticationAlertView = UIAlertController(title: "Authentication", message: "You must log into your CS account to use this feature", preferredStyle: .Alert)
        let submitAction = UIAlertAction(title: "Log in", style: .Default){ _ in
                let loginTextField = self.authenticationAlertView!.textFields![0] as UITextField
                let passwordTextField = self.authenticationAlertView!.textFields![1] as UITextField

                self.login(loginTextField.text!, password: passwordTextField.text!)

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel){ _ in}

        authenticationAlertView?.addAction(submitAction)
        authenticationAlertView?.addAction(cancelAction)
        authenticationAlertView!.addTextFieldWithConfigurationHandler({ (textfield) -> Void in
            textfield.placeholder = "CS Unix Username"
        })
        authenticationAlertView!.addTextFieldWithConfigurationHandler({ (textfield) -> Void in
            textfield.placeholder = "Password"
        })
    }
    func login(username: String, password: String){
        let hud = MBProgressHUD.showHUDAddedTo(verticalMenuViewController!.view, animated: true)
        hud.mode = .Indeterminate
        hud.labelText = "Authenticating"
        UTCSAuthenticationManager.sharedManager().authenticateUser(username, withPassword: password) { (success, error) -> Void in
            if success {
                if self.controllers[.Labs] == nil {
                    self.controllers[.Labs] = NavigationController(rootViewController: LabsViewController())
                }
                self.verticalMenuViewController?.contentViewController = self.controllers[.Labs]
            } else {
                let failureAlertView = UIAlertController(title: "Authentication Failed", message: "Ouch! Something went wrong.", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel){ _ in}
                failureAlertView.addAction(cancelAction)
            }
            MBProgressHUD.hideHUDForView(self.verticalMenuViewController!.view, animated: true)
        }
    }
}
