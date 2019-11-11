import UIKit
import Firebase
import FacebookCore
import FacebookLogin
import PushNotifications
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var unread_notifs: Int = 0
    
    var user_event_dates: [Date]!
    var pushNotification = PushNotifications.shared
    var publicLaunch: LaunchNotification?
    var user_location: CLLocation?
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        //push notification configuriation
        let remoteNotif = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as! [String: Any]?
        if remoteNotif != nil, let data = remoteNotif!["data"] as! [String:AnyObject]?, let type = data["type"] as! String?, let id = data["redirect"] as! String? {
            let public_launch_notif = LaunchNotification()
            public_launch_notif.isActive = true
            public_launch_notif.id = id
            public_launch_notif.type = type
            self.publicLaunch = public_launch_notif
        }
        
        self.pushNotification.start(instanceId: "a3bb9382-e554-4929-8b2a-bf4f728a67fa")
        self.pushNotification.registerForRemoteNotifications()
        
        FirebaseApp.configure()
        
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        
        self.setupStatusBar()
        self.setupNavigationBar()
        self.setupTabBar()
        
        self.window?.rootViewController = LoginController()
        self.window?.makeKeyAndVisible()
        
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.pushNotification.registerDeviceToken(deviceToken) {
            try? self.pushNotification.subscribe(interest: "debug-all")
            try? self.pushNotification.subscribe(interest: "notify-all")
            try? self.pushNotification.subscribe(interest: "debug-reilly")
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        self.pushNotification.handleNotification(userInfo: userInfo)
        let data = (userInfo["data"] as! NSDictionary)
        let badge = data.value(forKey: "badge") as! Int
        
        application.applicationIconBadgeNumber = badge
        
        if application.applicationState == .active {
            self.unread_notifs += 1
        } else if application.applicationState == .background {
            let redirectID = data.value(forKey: "redirect") as! String
            
            let currentController = self.window?.rootViewController?.presentedViewController as! TabBarController?
            
            Event.get(redirectID) { event in
                
                if event.isAttending {
                    let eventController = EventController()
                    eventController.event = event
                    
                    DispatchQueue.main.async {
                        self.window?.makeKeyAndVisible()
                        let currentNavController = currentController?.selectedViewController as! UINavigationController
                        currentNavController.pushViewController(eventController, animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.window?.makeKeyAndVisible()
                        let currentNavController = currentController?.selectedViewController as! UINavigationController
                        currentNavController.pushViewController(NotificationController(), animated: true)
                    }
                }

            }
            
            
            
        }
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.absoluteString.starts(with: "fb") {
            return SDKApplicationDelegate.shared.application(app, open: url, options: options)
        }
        return true
    }
    
    func setupNavigationBar(){
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
        UINavigationBar.appearance().barTintColor = UIColor.Theme.darkGray
    }
    
    
    func setupTabBar(){
        UITabBar.appearance().backgroundColor = UIColor.Theme.darkGray
        UITabBar.appearance().barTintColor = UIColor.Theme.darkGray
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.Theme.teal], for: .selected)
        //        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName:UIFont.systemFontSize(16)), for: .normal)
    }
    
    func setupStatusBar(){
        let statusBarView = UIView()
        statusBarView.backgroundColor = UIColor.Theme.darkGray
        self.window?.addSubview(statusBarView)
        self.window?.addConstraintsWithFormat(format: "H:|[v0]|", views: statusBarView)
        self.window?.addConstraintsWithFormat(format: "V:|[v0(20)]", views: statusBarView)
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("****applicationWillResignActive****")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("****applicationDidEnterBackground****")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("****applicationWillEnterForeground****")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("****applicationDidBecomeActive****")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("****applicationWillTerminate****")
    }
    
    
    
}
