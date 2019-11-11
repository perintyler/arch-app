/*
 * This file contains an extension for UIKit's UIColor class.
 * Functionality included:
 *      - Defined variables for colors used frequently thoughout the project
 *      - Constructor which uses a hex rgb value
 */

import Foundation
import UIKit

extension UIColor {
    
    struct Theme {
        static var teal : UIColor { return UIColor(rgb: 0x00F5FF) }
        static var lightTeal: UIColor { return UIColor(rgb: 0xD0FDFF)}
        static var lightGray: UIColor { return UIColor(rgb: 0xF8F8F8)}
        static var gray : UIColor { return UIColor(rgb: 0x232526) }
        static var darkGray : UIColor { return UIColor(rgb: 0x414345) }
        static var red: UIColor { return UIColor(rgb: 0xDD5444) }
        static var green: UIColor { return UIColor(rgb: 0x54C571) }
        static var blue: UIColor { return UIColor.init(red: 127/255, green: 208/255, blue: 222/255, alpha: 1) }
        static var lightBlue: UIColor { return UIColor.init(red: 127/255, green: 208/255, blue: 222/255, alpha: 1) }
        static var orange: UIColor { return UIColor.init(red: 244/255, green: 168/255, blue: 87/255, alpha: 1) }
        static var purple: UIColor { return UIColor(rgb: 0x826FE2) }
        static var yellow: UIColor { return UIColor(rgb: 0xF7CA45) }
        static var grayBlue: UIColor { return UIColor(rgb: 0x46535f)}
        static var vibrantRed: UIColor { return UIColor.init(red: 243/255, green: 116/255, blue: 116/255, alpha: 1) }
        static var vibrantOrange: UIColor { return UIColor.init(red: 244/255, green: 168/255, blue: 87/255, alpha: 1) }
        static var mellowYellow: UIColor { return UIColor(rgb: 0xffc400) }
        static var magenta: UIColor { return UIColor.init(red: 234/255, green: 128/255, blue: 188/255, alpha: 1) }
        static var vibrantPurple: UIColor { return UIColor.init(red: 164/255, green: 217/255, blue: 176/255, alpha: 1) }
        static var kush: UIColor { return UIColor(rgb: 0x465f52) }
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
}
