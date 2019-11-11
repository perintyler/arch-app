import Foundation
import UIKit
import CoreLocation

class VenueHeader: UITableViewCell {
    
    static let height: CGFloat = 350.0
    
    let imgView: CachedImageView = {
        let imageView = CachedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    let headerView: HeaderView = {
        let headers = HeaderView()
        headers.translatesAutoresizingMaskIntoConstraints = false
        headers.nameLabel.adjustsFontSizeToFitWidth = true
        headers.subHeaderTop.font = UIFont.systemFont(ofSize: 17)
        headers.nameLabel.textColor = UIColor.white
        headers.subHeaderTop.textColor = UIColor.white
        headers.subHeaderBottom.textColor = UIColor.white
        return headers
    }()
    
    let gradientView: UIImageView = {
        let gradient = UIImageView()
        gradient.translatesAutoresizingMaskIntoConstraints = false
        gradient.image = #imageLiteral(resourceName: "gradient")
        return gradient
    }()
    
    let createEventButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create Event", for: .normal)
        button.backgroundColor = UIColor.Theme.green
        button.layer.cornerRadius = 9
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.Theme.gray
        self.selectionStyle = .none
        self.addSubviews(self.imgView, self.createEventButton)
        
        // vertical
        self.addConstraintsWithFormat(format: "V:|[v0(250)]-15-[v1(70)]-15-|", views: self.imgView, self.createEventButton)

        
        // horizontal
        self.addConstraintsWithFormat(format: "H:|[v0]|", views: self.imgView)
        self.addConstraintsWithFormat(format: "H:|-[v0]-|", views: self.createEventButton)
        
        
        
        // add the header and gradient to the imageview
        self.imgView.addSubviews(self.gradientView, self.headerView)
        
        // veritcal gradient and header constraints
        self.imgView.addConstraintsWithFormat(format: "V:[v0(110)]|", views: self.gradientView)
        self.imgView.addConstraintsWithFormat(format: "V:[v0(60)]-10-|", views: self.headerView)
        // horizontal gradient and header constraints
        self.imgView.addConstraintsWithFormat(format: "H:|[v0]|", views: self.gradientView)
        self.imgView.addConstraintsWithFormat(format: "H:|-15-[v0]|", views: self.headerView)


    }
    
    func set(venue: Venue) {
        self.headerView.setLabels(name: venue.name, descTop: venue.address, descBottom: "")
        self.imgView.load(urlStr: venue.image)

    }
}
