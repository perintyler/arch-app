import Foundation
import UIKit

class ImageAndTextTableCell: UITableViewCell {
    
    var selectable: Bool = true
    
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
        text.font = UIFont(name: "HelveticaNeue", size: 20)
        text.textColor = UIColor.white
        text.adjustsFontSizeToFitWidth = true
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setImageCornerRadius(_ radius: CGFloat) {
        self.imgView.roundCorners(radius: radius)
    }
    
    func set(imgUrlStr: String, text: String) {
        self.imgView.set(urlStr: imgUrlStr)
        self.label.text = text
    }
    
    func setupViews(){
        self.addSubviews(views: self.imgView, self.label)
        self.addConstraintsWithFormat(format: "V:[v0(42)]", views: self.imgView)
    
        self.addConstraintsWithFormat(format: "H:|-25-[v0(42)]-25-[v1]-60-|", views: self.imgView, self.label)
        self.centerVertically(child: self.imgView)
        self.centerVertically(child: self.label)
    }

}
