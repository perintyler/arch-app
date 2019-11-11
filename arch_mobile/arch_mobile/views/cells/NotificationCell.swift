import Foundation
import UIKit

class NotificationCell: UITableViewCell {
    
    let imgView: UIImageView = {
        let imageSize: CGFloat = 42
        let groupImageView = UIImageView()
        groupImageView.roundCorners(radius: imageSize/2.0)
        groupImageView.clipsToBounds = true
        groupImageView.translatesAutoresizingMaskIntoConstraints = false
        return groupImageView
    }()
    
    let label: UILabel = {
        let text = UILabel()
        text.font = UIFont(name: "HelveticaNeue", size: 15)
        text.textColor = UIColor.white
        text.adjustsFontSizeToFitWidth = true
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()

    let acceptButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.roundCorners(radius: 8)
        button.layer.borderColor = UIColor.white.cgColor
        button.isUserInteractionEnabled = false
        return button
    }()

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.selectionStyle = .none
        self.addSubviews(self.imgView, self.label, self.acceptButton)
        
    
        
        // horizontal constraints
        self.addConstraintsWithFormat(format: "H:|-[v0(42)]-20-[v1]-[v2(90)]-|", views: self.imgView, self.label, self.acceptButton)
        
        // veritcal constraints
        self.centerVertically(child: self.acceptButton)
        self.centerVertically(child: self.label)
        self.centerVertically(child: self.imgView)

        self.addHeightConstraint(50.0, child: self.acceptButton)
        self.addHeightConstraint(42.0, child: self.imgView)

    }

    func set(_ notification: Notification) {
        self.label.text = notification.get_message()

        let img_url = notification.inviter.get_image_url()
        self.imgView.set(urlStr: img_url)
        
        self.label.lineBreakMode = .byWordWrapping
        self.label.numberOfLines = 3
        self.label.adjustsFontSizeToFitWidth = true
        self.backgroundColor = UIColor.Theme.gray
        if !(notification.viewed!) {
            self.backgroundColor = UIColor.Theme.lightTeal
        }
        
        if notification.accepted {
            self.acceptButton.layer.borderWidth = 1
            self.acceptButton.backgroundColor = UIColor.clear
            self.acceptButton.setTitle("Accepted", for: .normal)
        } else {
            self.acceptButton.layer.borderWidth = 0
            self.acceptButton.backgroundColor = UIColor.Theme.green
            self.acceptButton.setTitle("Accept", for: .normal)
        }
    }
    
}
