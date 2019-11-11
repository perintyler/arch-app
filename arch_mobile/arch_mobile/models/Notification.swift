import Foundation
import UIKit

struct Notification: Decodable {
    
    var event: Event
    var inviter: User
    var viewed: Bool?
    var accepted: Bool
    
    static func get_all(callback: @escaping ([Notification])->()) {
        rest.get(path: "notification/") { (data, response) in
        
            let decoder = JSONDecoder()
            let notifications = try! decoder.decode([Notification].self, from: data)
            callback(notifications)
        }
    }
    
    func get_message() -> String {
        return "\(self.inviter.name) invited you to an event on \(self.event.get_date().formatted())"
    }

}

