import Foundation
import UIKit

class EventCell: UITableViewCell {
    
    static let height: CGFloat = 150.0
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont(name: "Arial-BoldMT", size: 20)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "ArialMT", size: 15)
        label.textColor = UIColor.gray
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "ArialMT", size: 15)
        label.textColor = UIColor.gray
        return label
    }()
    
    let separator: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor.lightGray
        separator.isHidden = true
        return separator
    }()
    
    let attendanceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.Theme.teal, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        button.contentHorizontalAlignment = .left
        button.isUserInteractionEnabled = false
        return button
    }()
    
    let attendanceButtonArrow: UIImageView = {
        let image_view = UIImageView()
        image_view.translatesAutoresizingMaskIntoConstraints = false
        image_view.clipsToBounds = false
        image_view.contentMode = .scaleAspectFill
        image_view.tintColor = UIColor.Theme.teal
        image_view.image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        image_view.isHidden = true
        return image_view
    }()
    
    let imgView: CachedImageView = {
        let imageView = CachedImageView()
        imageView.image = UIImage(named: "event-default")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.roundCorners(radius: 8)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    func set(_ event: Event) {
        
        // load or download the cachable image
        event.get_image() { image in
            self.imgView.image = image
        }
        
        self.nameLabel.text = event.name
        self.addressLabel.text = event.venue.name
        self.dateLabel.text = event.get_date().formatted()
        
        if event.expired {
            self.attendanceButton.setTitle("\(event.attendance) Attended" , for: .normal)
            
            // set all labels to gray
            self.nameLabel.textColor = UIColor.gray
            self.attendanceButton.setTitleColor(UIColor.gray, for: .normal)
            
        } else {
            self.nameLabel.textColor = UIColor.white
            self.attendanceButton.setTitleColor(UIColor.Theme.teal, for: .normal)
            self.attendanceButton.setTitle("\(event.attendance) Attending" , for: .normal)
        }
        
    }
    
    
    func setAttendAction(action: Selector, target: EventController) {
        self.attendanceButton.isUserInteractionEnabled = true
        self.attendanceButton.addTarget(target, action: action, for: .touchUpInside)
        
        self.attendanceButtonArrow.isHidden = false
        self.separator.isHidden = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.selectionStyle = .none
        self.backgroundColor = UIColor.Theme.gray
        //label container contains the event label, date, venue name, and the attendance label/button. I put them all in
        //a parent view here to make constraints easier
        let label_container = UIView()
        label_container.translatesAutoresizingMaskIntoConstraints = false
        label_container.addSubviews(self.nameLabel, self.addressLabel, self.dateLabel)
        label_container.addConstraintsWithFormat(format: "V:|-[v0]-[v1]-[v2]|", views: self.nameLabel, self.addressLabel, self.dateLabel)
        label_container.addConstraintsWithFormat(format: "H:|-[v0]|", views: self.nameLabel)
        label_container.addConstraintsWithFormat(format: "H:|-[v0]", views: self.addressLabel)
        label_container.addConstraintsWithFormat(format: "H:|-[v0]", views: self.dateLabel)
        
        
        //add all subviews
        self.addSubviews(self.imgView, label_container, self.attendanceButton, self.attendanceButtonArrow, self.separator)
        
        //horizontal
        self.addConstraintsWithFormat(format: "H:|-[v0(120)]-[v1]-|", views: self.imgView, label_container)
        self.addConstraintsWithFormat(format: "H:[v0]-16-[v1][v2(15)]", views: self.imgView, self.attendanceButton, self.attendanceButtonArrow)
        self.addConstraintsWithFormat(format: "H:|-[v0]-|", views: self.separator)
        
        //vertical
        self.addConstraintsWithFormat(format: "V:|-[v0(120)]-16-[v1(2)]", views: self.imgView, self.separator)
        self.addConstraintsWithFormat(format: "V:|-[v0]-[v1]-|", views: label_container, self.attendanceButton)
        self.addConstraintsWithFormat(format: "V:[v0(15)]", views: self.attendanceButtonArrow)
        
        self.addConstraint(NSLayoutConstraint(item: self.attendanceButtonArrow, attribute: .centerY, relatedBy: .equal, toItem: self.attendanceButton, attribute: .centerY, multiplier: 1, constant: 0))
        
        
    }
    
    
}
