import Foundation
import UIKit

struct User: Decodable {
    
    var name: String
    var facebookID: String
    
    static func get_friends(callback: @escaping ([User])->()) {
        rest.get(path: "friends/") { (data, response) in
            let decoder = JSONDecoder()
            let users = try! decoder.decode([User].self, from: data)
            callback(users)
        }
    }
    
    static func is_free(on date: Date, callback: @escaping (Bool)->()) {
        if let event_dates = (UIApplication.shared.delegate as! AppDelegate).user_event_dates {
            callback(User.is_free_wrapper(date, event_dates: event_dates))
        } else {
            Event.get_attending { user_events in
                
                let event_dates = user_events.map { event in event.get_date() }
                
                DispatchQueue.main.async {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.user_event_dates = event_dates
                }
                callback(User.is_free_wrapper(date, event_dates: event_dates))
            }
        }
    }
    
    private static func is_free_wrapper(_ date: Date, event_dates: [Date]) -> Bool {
        var userIsFree = true
        for taken_date in event_dates {
            if date.isSameDay(as: taken_date) {
                userIsFree = false
                break
            }
        }
        return userIsFree
    }
    
    func get_image_url() -> String {
        return "http://graph.facebook.com/\(self.facebookID)/picture?type=small"
    }
    
}
