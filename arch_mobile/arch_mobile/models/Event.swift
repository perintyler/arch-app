import Foundation
import UIKit
import CoreLocation

struct Event: Decodable {
    
    var id: Int
    var name: String
    var venue: Venue
    var date: String
    var has_image: Bool
    var desc: String?!
    var attendance: Int
    var isAttending: Bool
    var expired: Bool
    var isCheckedIn: Bool!
    
    static func get_attending(callback: @escaping ([Event])->()) {
        rest.get(path: "event/") { data, response in
            let decoder = JSONDecoder()
            let events = try! decoder.decode([Event].self, from: data)
            callback(events)
        }
    }
    
    static func create(fields: [String: Any], callback: @escaping (Event)->()) {
        rest.post(path: "event/", params: fields) { data, response in
            print(data)
            print(response)
            let decoder = JSONDecoder()
            let event = try! decoder.decode(Event.self, from: data)
            callback(event)
        }
    }
    
    static func get(_ id: String, callback: @escaping (Event)->()) {
        rest.get(path: "event/\(id)/") { data, response in
            let decoder = JSONDecoder()
            let event = try! decoder.decode(Event.self, from: data)
            callback(event)
        }
    }
    
    func get_date() -> Date {
        return self.date.parseAsDate()
    }
    
    func get_image(callback: @escaping (UIImage)->()) {
        if self.has_image == false {
            // no custom event image. call the callback using the default event image
            callback(UIImage(named: "event-default")!)
        } else {
            let path = "event"
            let file_name = "\(self.id)"
            download_image(path: path, file_name: file_name, callback: callback)
        }
    }
    
    func set_image(image: UIImage) {
        let path = "event"
        let file_name = "\(self.id)"
        upload_image(image, path: path, file_name: file_name)
    }
    
    func isOngoing() -> Bool {
        return Date() > self.get_date()
    }
    
    func claim(_ discount: Discount) {
        let post_params: [String: Any] = ["discount": discount.id]
        rest.post(path: "event/\(self.id)/claim/", params: post_params)
    }
    
    
    func check_in() {
        rest.get(path: "event/\(self.id)/checkin/")
    }
    
    func invite(_ users: [User]) {
        let facebook_ids = users.map { user in user.facebookID }
        let post_params = ["facebook_ids": facebook_ids]
        rest.post(path: "event/\(self.id)/invite/", params: post_params)
    }
    
    func attend() {
        rest.get(path: "event/\(self.id)/attend/")
    }
    
    func leave(callback: @escaping ()->() ) {
        rest.get(path: "event/\(self.id)/leave/") { _,_ in
            callback()
        }
    }
    
    func get_discounts(callback: @escaping ([Discount])->()) {
        rest.get(path: "event/\(id)/discounts/") { data, response in
            let decoder = JSONDecoder()
            let discounts = try! decoder.decode([Discount].self, from: data)
            callback(discounts)
        }
    }
    
    func get_next_discount(callback: @escaping (Discount)->()) {
        rest.get(path: "event/\(self.id)/next_discount_tier/") { data, response in
            let decoder = JSONDecoder()
            let discount = try! decoder.decode(Discount.self, from: data)
            callback(discount)
        }
    }
    
    func get_attending(callback: @escaping ([User])->()) {
        rest.get(path: "event/\(self.id)/attending/") { data, response in
            let decorder = JSONDecoder()
            let users = try! decorder.decode([User].self, from: data)
            callback(users)
        }
    }
}
