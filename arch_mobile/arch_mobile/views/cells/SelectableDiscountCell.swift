import Foundation
import UIKit

class SelectableDiscountCell: UITableViewCell {
    
    let discountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        return label
    }()
    
    let claimButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.Theme.green
        button.setTitle("Claim", for: .normal)
        button.roundCorners(radius: 8.0)
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionStyle = .none
        
        self.backgroundColor = UIColor.Theme.gray
        self.addSubviews(self.discountLabel, self.claimButton)
        
        // horizontal constraints
        self.addConstraintsWithFormat(format: "H:|-[v0]", views: self.discountLabel)
        self.addConstraintsWithFormat(format: "H:[v0(100)]-|", views: self.claimButton)
        
        // veritcal constraints
        self.addConstraintsWithFormat(format: "V:|-[v0]-|", views: self.discountLabel)
        self.addWidthConstraint(100.0, child: self.claimButton)
        self.centerVertically(child: self.claimButton)
        
    }
    
    func set(_ discount: Discount, row: Int) {
        self.discountLabel.text = discount.formatted_string()
        self.claimButton.tag = row
    }
    
    func setClaimAction(selector: Selector, target: UIViewController) {
        self.claimButton.tag = tag
        self.claimButton.addTarget(target, action: selector, for: .touchUpInside)
    }
}
