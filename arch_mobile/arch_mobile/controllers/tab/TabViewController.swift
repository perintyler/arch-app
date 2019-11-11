import Foundation
import UIKit
import Firebase
import FacebookLogin

/*
 * All of the home screen tabs inherit this class, which sets up
 * the nav bar items, and their actions
 */
class TabViewController: UIViewController {
    
    var notifBarItem: NotificationBarItem!
    var displayedNotifCount: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.updateNotifBadge()
    }
    
    func updateNotifBadge() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let updated_notif_count = appDelegate.unread_notifs
        
        // check to see if the notification icon badge is showing the correct
        // number of unread notifications
        if self.displayedNotifCount != updated_notif_count {
            
            // first update displayedNotifCount and remove the currently displayed badge
            self.displayedNotifCount = updated_notif_count
            self.notifBarItem?.removeBadge()
            
            // if there is unread notifications, add a new badge
            if(updated_notif_count > 0) {
                self.notifBarItem?.addBadge(number: updated_notif_count)
            }
        }
        
    }
    
    private func setupNavigationItems(){
        //notification button
        let notifImage = UIImage(named: "notification-icon")!
        self.notifBarItem = NotificationBarItem(image: notifImage, style: .plain, target: self, action: #selector(self.goToNotifications))
        self.notifBarItem.tintColor = UIColor.Theme.teal
        
        //center logo icon
        let logoIconImg = UIImage(named: "logo-icon-small")
        let logoIconView = UIImageView()
        logoIconView.image = logoIconImg
        logoIconView.isUserInteractionEnabled = false
        
        //About Icon
        let aboutImage = UIImage(named: "help-icon")!
        let aboutBarItem = UIBarButtonItem(image: aboutImage, style: .plain, target: self, action: #selector(self.go_to_help))
        aboutBarItem.tintColor = UIColor.Theme.teal
        
        //logout button
        let logoutBarItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action:  #selector(self.logout))
        logoutBarItem.tintColor = UIColor.Theme.teal
        self.navigationItem.rightBarButtonItem = logoutBarItem
        
        
        //add created buttons to nav bar
        self.navigationItem.leftBarButtonItem = notifBarItem
        self.navigationItem.titleView = logoIconView
        self.navigationItem.rightBarButtonItems = [logoutBarItem, aboutBarItem] //logout button rightmost button
        
    }
    
    @objc func go_to_help() {
        let helpViewController = HelpViewController()
        helpViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(helpViewController, animated: true)
    }
    
    @objc func goToNotifications(){
        let notificationController = NotificationController()
        notificationController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(notificationController, animated: true)
    }
    
    @objc func logout() {
        let alertController = UIAlertController(title: nil,message: nil, preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (alertAction) in
            try! Auth.auth().signOut()
            LoginManager().logOut()
            DispatchQueue.main.async {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = LoginController()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cancelAction)
        alertController.addAction(logoutAction)
        self.present(alertController,animated: true, completion: nil)
    }
    
    
}
