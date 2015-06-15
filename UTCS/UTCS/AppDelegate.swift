import UIKit
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UTCSMenuViewControllerDelegate {
    var newsNavigationController: UTCSNavigationController?
    var eventsNavigationController: UTCSNavigationController?
    var directoryNavigationController: UTCSNavigationController?
    var settingsNavigationController: UTCSNavigationController?

    // Alert view used to authenticate the user (for any services that require authentication)
    var authenticationAlertView: UIAlertController?


    var menuViewController = UTCSMenuViewController()
    var verticalMenuViewController: UTCSVerticalMenuViewController?
    var labsViewController: UTCSLabsViewController?
    var diskQuotaViewController: UTCSDiskQuotaViewController?

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool  {
    
        // Menu
        self.menuViewController.delegate = self
        self.newsNavigationController = UTCSNavigationController(rootViewController:UTCSNewsViewController())
        self.verticalMenuViewController = UTCSVerticalMenuViewController(menuViewController: self.menuViewController, contentViewController: self.newsNavigationController)
        // Initialize view controllers. News is the default service

        window = UIWindow()
        window?.rootViewController = self.verticalMenuViewController;
        window?.makeKeyAndVisible()
        self.configureAppearance()
        return true
    }
    func applicationDidBecomeActive(application: UIApplication) {
        UTCSStarredEventsManager.sharedManager().purgePastEvents()
    }
    func applicationWillTerminate(application: UIApplication) {
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    func configureAppearance(){
        let array: [AnyObject.Type] = [UTCSNavigationController.Type]()
        let appearance = UINavigationBar.appearanceWhenContainedInInstancesOfClasses([UTCSNavigationController.Type]())
        appearance.tintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.clearColor()
        appearance.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        appearance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }

    func didSelectMenuOption(option: UTCSMenuOptions){
        switch option{
        case .News:
            if newsNavigationController == nil {
                newsNavigationController = UTCSNavigationController(rootViewController: UTCSNewsViewController())
            }
            verticalMenuViewController?.contentViewController = self.newsNavigationController
        case .Events:
            if eventsNavigationController == nil {
                eventsNavigationController = UTCSNavigationController(rootViewController: UTCSEventsViewController())
            }
            verticalMenuViewController?.contentViewController = self.eventsNavigationController
        case .Labs:
            if UTCSAuthenticationManager.sharedManager().authenticated{
                if labsViewController == nil {
                    labsViewController = UTCSLabsViewController()
                }
                verticalMenuViewController?.contentViewController = self.labsViewController
            } else {
                prepareAuthenticationAlertView()
                authenticationAlertView?.message = "You must log into your CS account to view lab status information."
                verticalMenuViewController?.presentViewController(authenticationAlertView!, animated: true, completion: nil)
            }
        case .Directory:
            if directoryNavigationController == nil {
                directoryNavigationController = UTCSNavigationController(rootViewController: UTCSDirectoryViewController())
                configureAppearance()
            }
            verticalMenuViewController?.contentViewController = self.directoryNavigationController
        case .DiskQuota:
            if diskQuotaViewController == nil {
                diskQuotaViewController = UTCSDiskQuotaViewController()
            }
            verticalMenuViewController?.contentViewController = self.diskQuotaViewController
        case .Settings:
            if settingsNavigationController == nil {
                settingsNavigationController = UTCSNavigationController(rootViewController: UTCSSettingsViewController())
            }
            self.verticalMenuViewController?.contentViewController = self.settingsNavigationController
        }
    }
    func prepareAuthenticationAlertView(){
        if authenticationAlertView == nil {
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
    }
    func login(username: String, password: String){
        let hud = MBProgressHUD.showHUDAddedTo(verticalMenuViewController!.view, animated: true)
        hud.mode = MBProgressHUDModeIndeterminate
        hud.labelText = "Authenticating"
        UTCSAuthenticationManager.sharedManager().authenticateUser(username, withPassword: password) { (success, error) -> Void in
            if success {
                if self.labsViewController == nil {
                    self.labsViewController = UTCSLabsViewController()
                }
                self.verticalMenuViewController?.contentViewController = self.labsViewController
            } else {
                let failureAlertView = UIAlertController(title: "Authentication Failed", message: "Ouch! Something went wrong.", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel){ _ in}
                failureAlertView.addAction(cancelAction)
            }
            MBProgressHUD.hideHUDForView(self.verticalMenuViewController!.view, animated: true)
        }
    }
}
