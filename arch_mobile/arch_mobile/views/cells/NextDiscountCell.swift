import Foundation
import UIKit

class NextDiscountCell: UITableViewCell {
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.text = "Next Available Discount"
        label.font = UIFont.Theme.mediumTitleLabel
        return label
    }()
    
    let discountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.Theme.teal
        label.font = UIFont.Theme.largeTitleLabel
        return label
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionStyle = .none
        self.backgroundColor = UIColor.Theme.gray
        
        self.addSubviews(self.headerLabel, self.discountLabel)
        
        // vertical constraints
        self.addConstraintsWithFormat(format: "V:|-[v0]-[v1]", views: self.headerLabel, self.discountLabel)
        
        // horizontal constraints
        self.addConstraintsWithFormat(format: "H:|-[v0]", views: self.headerLabel)
        self.addConstraintsWithFormat(format: "H:|-[v0]", views: self.discountLabel)
    }
    
    func set(_ discount: Discount) {
        self.discountLabel.text = discount.formatted_string()
    }

}

