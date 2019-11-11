import Foundation
import UIKit

class VenuePreviewCell: UITableViewCell {
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.Theme.mediumTitleLabel
        label.textColor = UIColor.white
        label.text = "Venue"
        return label
    }()
    
    let subheaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.Theme.smallTitleLabel
        label.textColor = UIColor.gray
        label.text = "(see all discounts)"
        return label
    }()
    
    let imgView: CachedImageView = {
        let imageView = CachedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 9
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    let nameView: GradientHeaderView = {
        let ghView = GradientHeaderView()
        ghView.translatesAutoresizingMaskIntoConstraints = false
        ghView.headerView.setNameFont(font: UIFont(name: "HelveticaNeue-Medium", size: 24)!)
        ghView.headerView.setColors(backgroundColor: UIColor.clear, textColor: UIColor.white)
        return ghView
    }()
    
    
    func set(_ venue: Venue){
        self.imgView.load(urlStr: venue.image)
        self.nameView.headerView.nameLabel.text = venue.name
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = UIColor.Theme.gray
        self.selectionStyle = .none
        
        self.addSubviews(self.headerLabel, self.subheaderLabel, self.imgView)
        self.addConstraintsWithFormat(format: "H:|-[v0]-[v1]", views: self.headerLabel, self.subheaderLabel)
        self.addConstraintsWithFormat(format: "H:|-[v0]-|", views: self.imgView)
        self.addConstraintsWithFormat(format: "V:|-[v0]-[v1]-|", views: self.headerLabel, self.imgView)
        self.addConstraintsWithFormat(format: "V:[v0]-[v1]", views: self.subheaderLabel, self.imgView)

        self.imgView.addSubviews(self.nameView)
        self.imgView.addConstraintsWithFormat(format: "H:|[v0]|", views: self.nameView)
        self.imgView.addConstraintsWithFormat(format: "V:[v0(80)]|", views: self.nameView)
    }
    
}
