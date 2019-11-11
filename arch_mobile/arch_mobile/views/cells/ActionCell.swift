import Foundation
import UIKit


class ActionCell: UITableViewCell {
    
    let friendImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.roundCorners(radius: 50.0/2.0)
        return imageView
    }()
    
    let displayMessage: UILabel = {
        let message = UILabel()
        message.translatesAutoresizingMaskIntoConstraints = false
        message.numberOfLines = 0
        message.lineBreakMode = .byWordWrapping
        message.textColor = UIColor.white
        return message
    }()
    
    let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    func set(_ action: Action) {
        let imgUrlStr = action.user.get_image_url()
        self.friendImgView.set(urlStr: imgUrlStr)
        
        DispatchQueue.main.async {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1
            
            let userName = NSMutableAttributedString(string: action.user.name, attributes: [NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-Bold", size: 18), NSAttributedStringKey.foregroundColor : UIColor.white])
            let isGoing = NSAttributedString(string: action.get_message(), attributes: [NSAttributedStringKey.font : UIFont(name: "HelveticaNeue", size: 18), NSAttributedStringKey.foregroundColor : UIColor.init(red: 213/255, green: 213/255, blue: 215/255, alpha: 1)])
            
            let finalText = NSMutableAttributedString()
            finalText.append(userName)
            finalText.append(isGoing)
            finalText.addAttributes([NSAttributedStringKey.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: finalText.length))
            
            self.displayMessage.attributedText = finalText
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.selectionStyle = .none
        self.backgroundColor = UIColor.Theme.gray
        self.addSubviews(self.friendImgView, self.displayMessage, self.divider)
        
        self.addConstraintsWithFormat(format: "H:|-30-[v0(55)]-20-|", views: self.friendImgView)
        self.addConstraintsWithFormat(format: "V:|-25-[v0(55)]-|", views: self.friendImgView)
        
        self.addConstraintsWithFormat(format: "V:|-10-[v0(80)]-[v1(3)]|", views: self.displayMessage, self.divider)
        self.addConstraintsWithFormat(format: "H:|-105-[v0]-|", views: self.displayMessage)
        self.addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: self.divider)
    }
    
}
