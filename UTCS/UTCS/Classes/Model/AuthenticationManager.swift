import Foundation
import NMSSH
import MBProgressHUD
import UIKit

typealias AuthenticationCompletion = (Bool, NSError?)->()
class AuthenticationManager {
    private(set) static var authenticated = false
    private static let server = "linux.cs.utexas.edu"
    private static var alertController: UIAlertController = AuthenticationManager.prepareAlertController()
    private static var completion: ((Bool, NSError?) -> ())?

    private static func authenticateUser(username: String, withPassword password: String, completion: AuthenticationCompletion?) {
        if AuthenticationManager.authenticated {
            completion?(true, nil)
            return
        }

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            let session = NMSSHSession.connectToHost(AuthenticationManager.server, withUsername: username)
            guard session.connected else {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    completion?(false, nil)
                }
                return
            }
            session.authenticateByPassword(password)
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                if session.authorized {
                    AuthenticationManager.authenticated = true
                    completion?(true, nil)
                } else {
                    completion?(false, nil)
                }
                session.disconnect()
            }
        }
    }

    static func presentAuthenticationAlert(hostController: UIViewController, reason: String, completion: ((Bool, NSError?) -> ())?) {
        AuthenticationManager.alertController.message = reason
        AuthenticationManager.completion = completion
        hostController.presentViewController(alertController, animated: true, completion: nil)
    }

    static func presentErrorAlert(hostController: UIViewController) {

    }

    private static func prepareAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: "Authentication", message: nil, preferredStyle: .Alert)
        let submitAction = UIAlertAction(title: "Log in", style: .Default) { _ in
            let loginTextField = self.alertController.textFields![0]
            let passwordTextField = self.alertController.textFields![1]
            guard let username = loginTextField.text,
                let password = passwordTextField.text else {
                    return
            }
            AuthenticationManager.login(username, password: password)

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { _ in}

        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        alertController.addTextFieldWithConfigurationHandler({ (textfield) -> Void in
            textfield.placeholder = "CS Unix Username"
        })
        alertController.addTextFieldWithConfigurationHandler({ (textfield) -> Void in
            textfield.placeholder = "Password"
            textfield.secureTextEntry = true
        })
        return alertController
    }

    private static func login(username: String, password: String) {
        let window = UIApplication.sharedApplication().windows.last!
        let hud = MBProgressHUD.showHUDAddedTo(window, animated: true)
        hud.mode = .Indeterminate
        hud.labelText = "Authenticating"

        AuthenticationManager.authenticateUser(username, withPassword: password) { (success, error) -> Void in
            AuthenticationManager.completion?(success,error)
            MBProgressHUD.hideHUDForView(window, animated: true)
        }
    }
}
