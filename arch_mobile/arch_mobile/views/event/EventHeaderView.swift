import UIKit

class EventHeader: UIView {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "Arial-BoldMT", size: 28)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let venueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ArialMT", size: 18)
        label.textColor = UIColor.gray
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ArialMT", size: 18)
        label.textColor = UIColor.gray
        return label
    }()
    
    let separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGray
        return separator
    }()
    
    let attendanceLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.textColor = UIColor.Theme.teal
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        return label
    }()
    
    let discountsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.init(red: 162/255, green: 233/255, blue: 145/255, alpha: 1)
        button.setTitle("Claim Discount", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    let imgView: CachedImageView = {
        let imageView = CachedImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.roundCorners(radius: 16)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let inviteFriendsButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "invite_friends"), for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.setupConstraints()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func set(event: Event) {
        event.get_image() { image in
            self.imgView.image = image
        }
        
        self.nameLabel.text = event.name
        self.venueLabel.text = event.venue.name
        self.dateLabel.text = event.date.formatted()
        self.attendanceLabel.text = "\(event.attendance.count) Attending"
    }
    
    func setActions(vc: UIViewController, inviteSelector: Selector, attendanceSelector: Selector) {
        
        let invite_gesture = UITapGestureRecognizer(target: vc, action: inviteSelector)
        self.inviteFriendsButton.addGestureRecognizer(invite_gesture)
        
        let attendance_gesture = UITapGestureRecognizer(target: vc, action: attendanceSelector)
        self.attendanceLabel.addGestureRecognizer(attendance_gesture)
        
    }
    
    private func setupConstraints(){
        
        //label container contains the event label, date, venue name, and the attendance label/button. I put them all in
        //a parent view here to make constraints easier
        let label_container = UIView()    
        label_container.addSubviews(self.nameLabel, self.venueLabel, self.dateLabel, self.attendanceLabel)
        label_container.addConstraintsWithFormat(format: "V:|[v0]-15-[v1]-[v2]-10-[v3]", views: self.nameLabel, self.venueLabel, self.dateLabel, self.attendanceLabel)
        label_container.addConstraintsWithFormat(format: "H:|[v0]|", views: self.nameLabel)
        label_container.addConstraintsWithFormat(format: "H:|[v0]", views: self.venueLabel)
        label_container.addConstraintsWithFormat(format: "H:|[v0]", views: self.dateLabel)
        label_container.addConstraintsWithFormat(format: "H:|[v0]", views: self.attendanceLabel)
        
        //add all subviews
        self.addSubviews(self.imgView, label_container, self.separator, self.inviteFriendsButton, self.discountsButton)

        //horizontal
        self.addConstraintsWithFormat(format: "H:|-[v0(120)]-16-[v1]-[v2(32)]-|", views: self.imgView, label_container, self.inviteFriendsButton)
        self.addConstraintsWithFormat(format: "H:|-[v0]-|", views: self.discountsButton)
        self.addConstraintsWithFormat(format: "H:|-[v0]-|", views: self.separator)

        //vertical
        self.addConstraintsWithFormat(format: "V:|-[v0(120)]-30-[v1(2)]-20-[v2(68)]", views: self.imgView, self.separator, self.discountsButton)
        self.addConstraintsWithFormat(format: "V:|-[v0]", views: label_container)
        self.addConstraintsWithFormat(format: "V:|-[v0(32)]", views: self.inviteFriendsButton)


    }
}
