import Foundation
import UIKit

class IconButton: UIButton {
    
    let iconView: UIImageView = {
        let icon = UIImageView()
        return icon
    }()
    
    let labelView: UILabel = {
        let label = UILabel()
        return label
    }()
    
    func set(icon: ButtonIcon, text: String) {
        let icon = UIImage(named: icon.rawValue)!
        self.iconView.image = icon
        self.labelView.text = text
    }
    
    func set(icon: UIImage, text: String) {
        self.iconView.image = icon
        self.labelView.text = text
    }
    
    func setColors(bg: UIColor, fg: UIColor) {
        if let icon = self.iconView.image {
            self.iconView.image = icon.withRenderingMode(.alwaysTemplate)
            self.iconView.tintColor = fg
            self.labelView.textColor = bg
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubviews(self.iconView, self.labelView)
        
        self.addConstraintsWithFormat(format: "H:|-[v0(36)]-36-[v1]", views: self.iconView, self.labelView)
        self.addConstraintsWithFormat(format: "V:[v0(36)]", views: self.iconView)
        self.centerVertically(child: self.iconView)
        self.centerVertically(child: self.labelView)
    }
    
}

enum ButtonIcon: String {
    typealias RawValue = String
    
    case add = "add-icon"
    case group = "group-icon"
    case delete = "delete-icon"
    case discount = "discount-icon"
    case event = "event-icon"
    case next = "next-icon"
    
}
