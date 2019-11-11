import Foundation
import UIKit


class StreamCell: UITableViewCell {
    
    let friendImgView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.roundCorners(radius: 50.0/2.0)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        return profileImageView
    }()
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.Theme.smallTitleLabel
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = UIColor.gray
        label.font = UIFont.Theme.detailsLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let divider: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func set(streamItem: StreamItem) {
        self.friendImgView.set(urlStr: Facebook.getPictureUrl(id: (streamItem.user.facebookID)))
        
        DispatchQueue.main.async {
            self.descLabel.text = streamItem.get_message()
            self.nameLabel.text = streamItem.user.name
        }
    }
    
    
    private func setupViews(){
        self.selectionStyle = .none
        self.backgroundColor = UIColor.Theme.gray
        self.addSubviews(views: self.friendImgView, self.nameLabel, self.descLabel, self.divider)
        

        self.addConstraintsWithFormat(format: "H:|-30-[v0(55)]-20-[v1]-|", views: self.friendImgView, self.nameLabel)
        self.addConstraintsWithFormat(format: "V:|-[v0(55)]-|", views: self.friendImgView)
        
        self.addConstraint(NSLayoutConstraint(item: self.nameLabel, attribute: .centerY, relatedBy: .equal, toItem: self.friendImgView, attribute: .centerY, multiplier: 1, constant: 0))

        self.addConstraintsWithFormat(format: "V:[v0(30)]-10-[v1(60)]-70-[v2(3)]|", views: self.nameLabel, self.descLabel, self.divider)
        self.addConstraintsWithFormat(format: "H:|-105-[v0]-|", views: self.descLabel)
        self.addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: self.divider)

    }
    
}
