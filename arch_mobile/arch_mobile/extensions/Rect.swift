/*
 * This file contains an extension for UIKit's CGRect class.
 * Functionality included:
 *      - get center point of a rectangle
 */


import Foundation
import UIKit

extension CGRect {
    var center: CGPoint { return CGPoint(x: midX, y: midY) }
    
    init(format: String){
        var data: [CGFloat] = []
        var str = ""
        for char in format {
            if (char == "-"){
                data.append(CGFloat(str.floatValue))
            } else {
                str += String(char)
            }
        }
        
        self.init(x: data[0], y: data[1], width: data[2], height: data[3])
    }
}

