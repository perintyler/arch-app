import Foundation
import UIKit
import CoreLocation
import Firebase
import FacebookLogin

/*
 * This controller displays all venues and is one of the home screen tab views.
 * Users can navigate to venue pages by clicking on a venue cell.
 */
class VenueTableController: TabViewController {
    
    var venues: [Venue] = [] // populated in view did load
    var userLocation: CLLocation!
    var venueTable: UITableView!
    
    let location_manager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()

    
    override func viewDidLoad(){
        super.viewDidLoad()

        // set the background color of the main view
        self.view.backgroundColor = UIColor.Theme.gray
       
        // get the users location to set the distance labels
        self.fetch_location()
        
        // setup layout, datasource, and delegate of venue table
        self.setupVenueTable()
        self.populate_table()

    }
    
    /*
     * Creates a location manager that starts updating the users location. After the first
     * location is retrieved, the location manager stops updating.
     */
    private func fetch_location() {
        
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus != .authorizedWhenInUse {
            self.location_manager.requestWhenInUseAuthorization()
        }
        
        // set the deleegate of the location manager
        self.location_manager.delegate = self
        
        
        // start updating the user location. The location stops getting updated once
        // the first location is retrieved
        location_manager.startUpdatingLocation()
    }
    
    private func setupVenueTable() {
        self.venueTable = UITableView(frame: self.view.bounds)
        self.venueTable.backgroundColor = UIColor.Theme.gray
        self.venueTable.separatorColor = UIColor.white
        self.venueTable.separatorStyle = .singleLineEtched
        self.venueTable.rowHeight = 280.0
        self.venueTable.register(VenueCell.self, forCellReuseIdentifier: "venueCell")
        
        self.view.addSubview(self.venueTable)
    }
    
    private func populate_table() {
        Venue.get_all { venues in
            self.venues = venues
            DispatchQueue.main.async {
                self.venueTable.dataSource = self
                self.venueTable.delegate = self
                self.venueTable.reloadData()
            }
        }
    }
    
}

extension VenueTableController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // create venue cell from indexpath
            let venueCell : VenueCell = tableView.dequeueReusableCell(withIdentifier: "venueCell", for: indexPath) as! VenueCell
            // setup and return the venue cell
            let venue = self.venues[indexPath.row]
            venueCell.set(venue, user_location: self.userLocation)
            return venueCell
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.venues.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let venueController: VenueController = VenueController()
        let venue = self.venues[indexPath.row]
        venueController.venue = venue
        venueController.user_location = self.userLocation
        venueController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(venueController, animated: true)
    }
    
}

extension VenueTableController: CLLocationManagerDelegate {
    /*
     * Called one time and then the location manager stops updating. Constantly updating the
     * user location will drain battery and we don't really need to update the distance labels
     * too often.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // store the user location
        self.userLocation = locations.last!
        
        // stop updating now that we have the users location
        manager.stopUpdatingLocation()
        
        // save the user location in shared app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.user_location = self.userLocation
        
        // reload the venue table now the distance labels can be set
        self.venueTable.reloadData()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Location error in venue table controller")
    }
}
