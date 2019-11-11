import Foundation
import UIKit

struct Discount: Decodable {
    
    var id: Int
    var size: Int
    var type: String
    var constant: Int?
    
    
    func formatted_string() -> String {
        if let constant = self.constant {
            let pattern = "\\*"
            let regex = try! NSRegularExpression(pattern: pattern, options: [])
            let range = NSMakeRange(0, self.type.count)
            let formatted_str = regex.stringByReplacingMatches(in: self.type, options: [], range: range, withTemplate: "\(constant)")
            return formatted_str
        } else {
            return self.type
        }
    }
    
//    func get_color() -> UIColor {
//        let colors = [UIColor.Theme.blue, UIColor.Theme.vibrantRed, UIColor.Theme.vibrantOrange, UIColor.Theme.vibrantPurple, UIColor.Theme.mellowYellow, UIColor.Theme.lightBlue]
//        return colors.randomElement()!
//    }
    
    func get_color() -> UIColor {
        let colors = [UIColor.Theme.blue, UIColor.Theme.vibrantRed, UIColor.Theme.vibrantOrange, UIColor.Theme.vibrantPurple, UIColor.Theme.mellowYellow, UIColor.Theme.lightBlue]
        return colors[self.size % colors.count]
    }
    
}









