import Foundation
import UIKit

class DescriptionCell: UITableViewCell {
    
    static let font: UIFont = UIFont.Theme.detailsLabel
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.Theme.mediumTitleLabel
        label.textColor = UIColor.white
        label.text = "Description"
//        label.numberOfLines = 50
        
        return label
    }()
    
    let paragraphLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = DescriptionCell.font
        label.textColor = UIColor.gray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    static func get_height(text: String, width: CGFloat) -> CGFloat {
        let horizontalMargin: CGFloat = 16.0
        let textHeight = text.height(withConstrainedWidth: width - horizontalMargin, font: DescriptionCell.font)
        let marginHeight: CGFloat = 40.0
        let titleHeight: CGFloat = 30.0
        return textHeight + marginHeight + titleHeight
    }
    
    func set(_ text: String){
        self.paragraphLabel.text = text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionStyle = .none
        self.addSubviews(self.titleLabel, self.paragraphLabel)
        self.addConstraintsWithFormat(format: "H:|-[v0]-|", views: self.titleLabel)
        self.addConstraintsWithFormat(format: "H:|-[v0]-|", views: self.paragraphLabel)
        self.addConstraintsWithFormat(format: "V:|-[v0(30)]-10-[v1]-|", views: self.titleLabel, self.paragraphLabel)
    }
    
}
