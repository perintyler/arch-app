import Foundation
import UIKit
import Firebase
import FacebookCore
import FacebookLogin
import CoreLocation

/*
 * This is the first controller to be pushed to the stack upon launch. It controls a simple view
 * containing only an image of the arch-logo and a facebook button which the user can use to login
 * into facebook. If the user has previously logged into the app, a silent login occurs. Every
 * time the user logs in, a login api call is made which either creates a new user in the db, or updates
 * an existing users info if there are any changes.
 */
class LoginController: UIViewController, LoginButtonDelegate {
    
    
    let logoView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Theme.darkGray
        
        //setup sdk built in FB login button
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends])
        loginButton.delegate = self
        loginButton.center = self.view.center
        loginButton.center.y += 100
        self.view.addSubview(loginButton)
        
        //set up frame for image view displaying arch logo
        let logoFrame = CGRect(x: 50.0, y: 100, width: self.view.frame.width - 100.0, height: 0.33*self.view.frame.height)
        self.logoView.frame = logoFrame
        self.view.addSubview(self.logoView)
        
        //try to silently log in
        if (Auth.auth().currentUser != nil) {
            DispatchQueue.main.async {
                self.present(TabBarController(), animated: true)
            }
        }
        
    }
    
    //after logging in with facebook, the user needs to be authenticated with facebook
    //which can be done using the retrieved facebook auth token
    func authenticate_with_firebase(token: String) {
        
        //get credentials from facebook auth
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print(error)
                return
            } else {
                
                
                // check to see if the user is new
                if authResult?.additionalUserInfo?.isNewUser == true {
                    // get the new users firebase uid from the auth results
                    let new_user_uid = authResult!.user.uid
                    
                    // subscribe the new users to push notifications using its uid
                    let pushNotification = (UIApplication.shared.delegate as! AppDelegate).pushNotification
                    try! pushNotification.subscribe(interest: new_user_uid)
                    
                    //navigate to the help slides tutorial
                    self.present_help_slides()
                } else {
                    // existing user: navigate to the main tabs screen
                    self.present(TabBarController(), animated: false, completion: nil)
                }
            }
        }
    }
    
    
    func present_help_slides() {
        let helpViewController = HelpViewController()
        helpViewController.onboarding = true
        self.present(helpViewController, animated: true)
    }
    
    
    //built in sdk facebook button delegate function which gets called after a fb login
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .failed(let error):
            print(error)
        case .cancelled:
            print("User cancelled login.")
        case .success( _, _, let accessToken):
            self.authenticate_with_firebase(token: accessToken.authenticationToken)
            print(accessToken.authenticationToken)
        }
    }
    
    //fb login delegate function that needs to be declared. Currently doesn't need to do anything
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        return
    }
    
    
}
