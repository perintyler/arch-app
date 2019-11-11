import Foundation
import UIKit

class SplitButtonCell: UITableViewCell {
    
    let buttonA: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.roundCorners(radius: 8.0)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()
    
    let buttonB: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.roundCorners(radius: 8.0)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionStyle = .none
        self.backgroundColor = UIColor.Theme.gray
        
        // add the subview buttons
        self.addSubviews(self.buttonA, self.buttonB)
        
        // horizontal
        self.addConstraintsWithFormat(format: "H:|-[v0]-[v1]-|", views: self.buttonA, self.buttonB)
        
        // vertical
        self.addConstraintsWithFormat(format: "V:|-[v0]-|", views: self.buttonA)
        self.addConstraintsWithFormat(format: "V:|-[v0]-|", views: self.buttonB)
        
        // set the buttons to be equal heights
        self.addConstraint(NSLayoutConstraint(item: self.buttonA, attribute: .width, relatedBy: .equal, toItem: self.buttonB, attribute: .width, multiplier: 1, constant: 0))
    }
    
    func setColors(colorA: UIColor, colorB: UIColor) {
        self.buttonA.backgroundColor = colorA
        self.buttonB.backgroundColor = colorB
    }
    
    func setTitles(titleA: String, titleB: String) {
        self.buttonA.setTitle(titleA, for: .normal)
        self.buttonB.setTitle(titleB, for: .normal)
        
    }
}
