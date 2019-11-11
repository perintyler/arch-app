import Foundation
import UIKit
import CoreLocation

//Venue cells are used in a venue table (venue tab)
class VenueCell: UITableViewCell {
    
    var displayDiscountPreview: Bool = true // switch to false to hide the discount label
    var showHeader: Bool = false // switch to true to display a header above the venue image titled 'Venue'
    
    let imgView: CachedImageView = {
        let imageView = CachedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 9
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let nameView: GradientHeaderView = {
        let ghView = GradientHeaderView()
        ghView.translatesAutoresizingMaskIntoConstraints = false
        ghView.headerView.setNameFont(font: UIFont(name: "HelveticaNeue-Medium", size: 24)!)
        ghView.headerView.setColors(backgroundColor: UIColor.clear, textColor: UIColor.white)
        return ghView
    }()
    
    let discountPreview: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(patternImage: UIImage(named: "gradient")!)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.Theme.teal
        label.font = UIFont.Theme.mediumTitleLabel
        return label
    }()
    
    let headerTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont.Theme.mediumTitleLabel
        return label
    }()
    
    let subHeaderTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.gray
        label.font = UIFont.Theme.smallTitleLabel
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func set(_ venue: Venue, user_location: CLLocation?){
        //        if let user_loc = user_location {
        //            // get distance from venue to user loc as a formatted string
        //            venue.get_formatted_distance(to: user_loc) { distance in
        //                // set distance label
        //                self.distanceLabel.text = distance
        //            }
        //        }
        
        // set venue image and main name label
        let discount = venue.get_discount_preview()
        self.discountPreview.text = discount.formatted_string()
        self.imgView.load(urlStr: venue.image)
        self.nameView.headerView.nameLabel.text = venue.name
        
        if self.displayDiscountPreview == false {
            self.discountPreview.isHidden = true
        } else {
            self.discountPreview.isHidden = false
        }
        
        if self.showHeader == true {
            self.headerTitle.text = "Venue"
            self.subHeaderTitle.text = "(See all discounts)"
            self.imgView.layer.borderWidth = 1
        } else {
            self.headerTitle.text = nil
            self.subHeaderTitle.text = nil
            self.imgView.layer.borderWidth = 0
        }
        
        
    }
    
    private func setupViews(){
        self.backgroundColor = UIColor.Theme.gray
        self.selectionStyle = .none
        
        self.addSubviews(self.imgView, self.headerTitle, self.subHeaderTitle)
        
        self.addConstraintsWithFormat(format: "H:|-[v0]-|", views: self.imgView)
        self.addConstraintsWithFormat(format: "H:|-[v0]-[v1]", views: self.headerTitle, self.subHeaderTitle)
        self.addConstraintsWithFormat(format: "V:|-[v0]-[v1]-|", views: self.headerTitle, self.imgView)
        self.addConstraintsWithFormat(format: "V:[v0]-[v1]", views: self.subHeaderTitle, self.imgView)

        self.imgView.addSubviews(self.nameView, self.discountPreview)
        self.imgView.addConstraintsWithFormat(format: "H:|-[v0]", views: self.discountPreview)
        self.imgView.addConstraintsWithFormat(format: "V:|-[v0]", views: self.discountPreview)
        
        self.imgView.addConstraintsWithFormat(format: "H:|[v0]|", views: self.nameView)
        self.imgView.addConstraintsWithFormat(format: "V:[v0(80)]|", views: self.nameView)
    }
    
}
