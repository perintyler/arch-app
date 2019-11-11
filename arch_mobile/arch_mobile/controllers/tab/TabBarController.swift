import Foundation
import UIKit
import CoreLocation
import Firebase
import FacebookLogin

/*
 * After login, this the first controller presented. It initiates, three view controllers: Event
 * Collection Controller, Venue Table Controller, and Stream Controller, which are set as
 * tab items for the tab controller.
 */
class TabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor.Theme.teal
        self.setupControllers()
        
        //        if(CLLocationManager.authorizationStatus() != .authorizedWhenInUse) {
        //            locationManager.requestWhenInUseAuthorization()
        //        }
    }
    
    
    private func setupControllers() {
        let venueTabController = self.get_venue_tab_controller()
        let eventTabController = self.get_event_tab_controller()
        let streamTabController = self.get_stream_tab_controller()
        
        self.viewControllers = [venueTabController, eventTabController, streamTabController]
    }
    
    private func get_venue_tab_controller() -> UINavigationController {
        let venueTableController = VenueTableController()
        
        let venueTabIcon = UIImage(named: "venue-icon")!.withRenderingMode(.alwaysTemplate)
        venueTableController.tabBarItem = UITabBarItem(title: "Venues", image: venueTabIcon, tag: 0)
        
        return UINavigationController(rootViewController: venueTableController)
    }
    
    private func get_event_tab_controller() -> UINavigationController {
        let eventTableController = EventTableController()
        let eventTabIcon = UIImage(named: "event-icon")!.withRenderingMode(.alwaysTemplate)
        eventTableController.tabBarItem = UITabBarItem(title: "Events", image: eventTabIcon, tag: 1)
        return UINavigationController(rootViewController: eventTableController)
    }
    
    private func get_stream_tab_controller() -> UINavigationController {
        let actionTableController = ActionTableController()
        let streamTabIcon = UIImage(named: "stream-icon")!.withRenderingMode(.alwaysTemplate)
        actionTableController.tabBarItem = UITabBarItem(title: "Stream", image: streamTabIcon, tag: 2)
        return UINavigationController(rootViewController: actionTableController)
        
    }
    
    private func handle_public_launch() {
        self.selectedIndex = 1
        
    }
}
