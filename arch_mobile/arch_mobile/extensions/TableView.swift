/*
 * This file contains an extension for UIKit's UITableView class.
 * Functionality included:
 *      - set a message to be displayed when there are no cells in a table view
 */

import Foundation
import UIKit

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.Theme.smallTitleLabel
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel;
        
        self.separatorColor = UIColor.clear
    }
    
    func restore() {
        self.separatorColor = UIColor.lightGray
        self.backgroundView = nil
    }
}
