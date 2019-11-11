
import Foundation
import UIKit
import CoreLocation

class Location {
    
    static func user_loc_available() -> Bool {
        return true
    }
    static func format_address(address: String, city: String, state: String, zip: String) -> String {
        return  String(format: "%a, %c, %s %z", address, city, state, zip)
    }
    static func checkAuthorization(locationManager : CLLocationManager){
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        if !CLLocationManager.locationServicesEnabled() {  //check if Location services are available.
            print("turn on location services")
            return
        }
    }
    

    
    /*
     Takes an address as a string and returns the users current distance as a formated string e.g. '0.4 miles'
     */
    static func distance(from locA: String, to locB: CLLocation, callback: @escaping (String)->()){
        Location.getCLLocation(from: locA,callback: { (location) in
            let distance_in_meters = Location.distance(from: location, to: locB)
            let distance_in_miles = 0.000621371 * distance_in_meters
            callback("\(distance_in_miles.rounded(toPlaces: 2)) miles")
        })
    }

    static func distance_in_miles(from: CLLocation, to: CLLocation) -> Double {
        let distance_in_meters = to.distance(from: from)
        let distance_in_miles = 0.000621371 * distance_in_meters
        return distance_in_miles.rounded(toPlaces: 2) // return the distance in miles, rounded to 2 decimal places
    }
    
    static func distance(from: CLLocation, to: CLLocation) -> Double {
        return to.distance(from: from)
    }
    
    static func getCLLocation(from address: String,callback: @escaping(CLLocation) -> Void){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString("\(address), St. Louis, MO") { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    let coordinate = location.coordinate
                    
                    callback(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
                    return
                }
            }else{
                print("error getting location from address")
                return
            }
        }
    }
    
}

