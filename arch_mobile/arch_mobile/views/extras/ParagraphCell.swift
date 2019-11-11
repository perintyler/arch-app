import Foundation
import UIKit

class DescriptionCell: UITableViewCell {
    
    static let font: UIFont = UIFont.Theme.detailsLabel
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.Theme.mediumTitleLabel
        label.textColor = UIColor.white
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
        let textHeight = text.height(withConstrainedWidth: width, font: DescriptionCell.font)
        let marginHeight: CGFloat = 30.0
        return textHeight + marginHeight
    }

    func set(_ text: String){
        self.paragraphLabel.text = text
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(self.paragraphLabel)
        self.addConstraintsWithFormat(format: "H:|-10-[v0]-10-[v1]-10-|", views: self.titleLabel, self.paragraphLabel)
        self.addConstraintsWithFormat(format: "V:|[v0(30)]-10-[v1]|", views: self.titleLabel, self.paragraphLabel)
    }
    
}
