import Foundation
import CoreLocation


struct Venue: Decodable {
    
    var id: Int
    var name: String
    var address: String
    var image: String
    var desc: String
    var discounts: [Discount]
    

    /*
     * Makes get request to api which gets all venues
     */
    static func get_all(callback: @escaping ([Venue])->()) {
        rest.get(path: "venue/") { (data, response) in
            let decoder = JSONDecoder()
            let venues = try! decoder.decode([Venue].self, from: data)
            callback(venues)
        }
    }
    
    /*
     * Gets the distance in miles as a string in format: "X.YZ mi"
     */
    func get_formatted_distance(to destination: CLLocation, callback: @escaping (String)->()) {
        // get the CLLocation using this venues address
        self.get_location { venue_loc in
            //get the distance in miles from the given location
            let distance = Location.distance_in_miles(from: venue_loc, to: destination)
            //create and pass a formatted string to the callback function
            let formatted_distance = "\(distance) mi"
            callback(formatted_distance)
        }
    }

    func get_discount_preview() -> Discount {
        let freeShotDiscounts = self.discounts.filter { $0.type == "Free Shot"}
        if freeShotDiscounts.isEmpty {
            return self.discounts.max { $0.size < $1.size }!
        } else {
            return freeShotDiscounts.first!
        }
    }
    
    // get cllocation using venues adress
    func get_location(callback: @escaping (CLLocation)->()) {
        Location.getCLLocation(from: self.address) { (clLoc) in
            callback(clLoc)
        }
    }
}
