import Foundation
import UIKit

class Notification {
    
    var notifType: NotifType
    var redirectID: String
    var imgUrlStr: String
    var itemName: String? //for group or event
    var friendName: String?
    var viewed: Bool?
    
    init(notifType: String, redirectID: String, imgUrlStr: String, itemName: String?, friendName: String?, viewed: Bool?) {
        self.notifType = notifType == "addedToGroup" ? .group : .event
        self.redirectID = redirectID
        self.imgUrlStr = imgUrlStr
        self.itemName = itemName
        self.friendName = friendName
        self.viewed = viewed
    }
    
    func get_message() -> String {
        // change these to class objects instead? idgaf
        var notifBody = ""
        
        if(self.notifType == .group) {
            notifBody = "\(self.friendName!) added you to their group \(self.itemName!.capitalized)"
        } else { //invited to event
            let eventNameString = String(self.itemName!).uppercased()
            notifBody = "\(self.friendName!) added you to their event \(eventNameString)"
        }
        
        return notifBody
    }
    
    func get_redirect_controller() -> UIViewController {
//        if(self.notifType == .group) {
//            let groupController = GroupController()
//            groupController.groupID = self.redirectID
//            return groupController
//        } else {
        let eventController = EventController()
        eventController.eventID = self.redirectID
        return eventController
//        }
    }
    
    
}

enum NotifType {
    case group
    case event
}
