import Foundation
import UIKit


class ImageAndTextCell: UICollectionViewCell {
    
    let imgView: UIImageView = {
        let imageSize: CGFloat = 75.0
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.roundCorners(radius: imageSize/2.0)
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.borderWidth = 1.0
        imageView.sizeToFit()
        return imageView
    }()
    
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    func set(imageUrlStr: String, text: String) {
        self.imgView.set(urlStr: imageUrlStr)
        self.label.text = text
    }
    
    func set(staticImageName: String) {
        self.imgView.image = UIImage(named: staticImageName)
    }
    
    func set(text: String){
        self.label.text = text
    }
    
    override func layoutSubviews() {
        self.addSubviews(self.imgView, self.label)
        self.centerHorizontally(child: self.imgView)
        self.addConstraintsWithFormat(format: "H:[v0(75)]", views: self.imgView)
        self.addConstraintsWithFormat(format: "H:|-[v0]-|", views: self.label)
        self.addConstraintsWithFormat(format: "V:|-[v0(75)]-[v1]-|", views: self.imgView, self.label)
    }
    
}

