import Foundation
import UIKit

class DiscountCell: UICollectionViewCell {
    
    let border_thickness: CGFloat = 2.0
    
    let label: UILabel = {
        let label_view = UILabel()
        label_view.translatesAutoresizingMaskIntoConstraints = false
        label_view.adjustsFontSizeToFitWidth = true
        label_view.textAlignment = .center
        return label_view
    }()
    
    func setup_header_cell(indexPath: IndexPath) {
        self.label.textColor = UIColor.gray
        self.label.font = UIFont.Theme.smallTitleLabel


        if indexPath.row == 0 {
            self.label.text = "Group Size"
        } else {
            self.layer.addBorder(edge: .left, color: UIColor.gray, thickness: self.border_thickness)
            self.label.text = "Discount"
        }
        
    }
    
    func set(discounts: [Discount], indexPath: IndexPath) {
        
        let discount = discounts[indexPath.section - 1] //row - 1 to account for header row
        
        self.label.font = UIFont.Theme.smallTitleLabel
        if indexPath.row == 0 {
            self.label.textColor = UIColor.Theme.subtle_orange

            var label_text: String? = nil
            
            var section_iter = indexPath.section
            var next_discount: Discount? = section_iter == discounts.count ? nil : discounts[section_iter]
            while next_discount != nil && label_text == nil {
                if next_discount!.size != discount.size {
                    label_text = "\(discount.size) - \(next_discount!.size - 1)"
                } else {
                    section_iter += 1
                    next_discount = section_iter >= discounts.count ? nil : discounts[section_iter]
                }
            }
            if next_discount == nil {
                label_text = "\(discount.size)+"
            }
            self.label.text = label_text
        } else {
            self.label.textColor = UIColor.Theme.teal
            self.label.text = discount.formatted_string()
            
            self.layer.addBorder(edge: .left, color: UIColor.gray, thickness: self.border_thickness)

        }
        
        self.layer.addBorder(edge: .top, color: UIColor.gray, thickness: self.border_thickness)
        
        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(self.label)
        self.fit(subview: self.label)
//        self.centerVertically(child: self.label)
//        self.centerHorizontally(child: self.label)
    }
}
