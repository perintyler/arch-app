import Foundation
import UIKit
import CoreLocation
import MapKit

class MapCell: UITableViewCell { 
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.font = UIFont.Theme.mediumTitleLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        return label
    }()
    
    let map: MKMapView = {
        let mkmap = MKMapView()
        mkmap.translatesAutoresizingMaskIntoConstraints = false
        mkmap.isZoomEnabled = true
        mkmap.isScrollEnabled = true
        mkmap.isPitchEnabled = true
        mkmap.setUserTrackingMode(.follow, animated: true)
        mkmap.roundCorners(radius: 16.0)
        return mkmap
    }()
    
    func set(venue: Venue, user_loc: CLLocation) {
        // get CLLocation object from venue
        venue.get_location { venue_loc in
            
            // get the distance from the venue to the user
            let distance = venue_loc.distance(from: user_loc)
            
            // set the map size using the distance, using the user location as the center of the map
            let mapSize = 3*distance
            let region = MKCoordinateRegionMakeWithDistance(user_loc.coordinate, mapSize, mapSize)
            
            // make a pin for the venue on the map
            let destinationPin = MKPointAnnotation()
            destinationPin.coordinate = venue_loc.coordinate
            destinationPin.title = venue.name
            
            DispatchQueue.main.async {
                
                self.map.setRegion(region, animated: true)
                self.map.addAnnotation(destinationPin)
                
                //this is a weird fix for the annotation title not show. i select and
                //unselct it with no animations to make the title appear
                self.map.selectAnnotation(destinationPin, animated: false)
                self.map.selectedAnnotations = []
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionStyle = .none
        self.addSubviews(self.titleLabel, self.map)
        
        // vertical
        self.addConstraintsWithFormat(format: "V:|-[v0]-[v1]-|", views: self.titleLabel, self.map)

        // horizontal
        self.addConstraintsWithFormat(format: "H:|-[v0]-|", views: self.titleLabel)
        self.addConstraintsWithFormat(format: "H:|-[v0]-|", views: self.map)
    }
}
