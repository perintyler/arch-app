import Foundation
import UIKit

class HeaderView: UIView {
    
    let subHeaderTop: UILabel = {
        let label = UILabel()
        label.font = UIFont.Theme.detailsLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subHeaderBottom: UILabel = {
        let label = UILabel()
        label.font = UIFont.Theme.detailsLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Theme.largeTitleLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.setupViews()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setColors(backgroundColor: UIColor, textColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.nameLabel.textColor = textColor
        self.subHeaderTop.textColor = textColor
        self.subHeaderBottom.textColor = textColor
    }
    
    func setLabels(name: String, descTop: String, descBottom: String){
        self.nameLabel.text = name
        self.subHeaderTop.text = descTop
        self.subHeaderBottom.text = descBottom
    }
    
    func setNameFont(font: UIFont){
        self.nameLabel.font = font
    }
    
    func setMainHeader(text: String){
        self.nameLabel.text = text
    }
    
    func setTopSubHeader(text: String){
        self.subHeaderTop.text = text
    }
    
    func setBottomSubHeader(text: String){
        self.subHeaderBottom.text = text
    }
    func setFonts(mainFont: UIFont, subFont: UIFont){
        self.nameLabel.font = mainFont
        self.subHeaderTop.font = subFont
        self.subHeaderBottom.font = subFont
    }

    private func setupViews() {
        self.addSubviews(self.nameLabel, self.subHeaderTop, self.subHeaderBottom)
        self.addConstraintsWithFormat(format: "V:|[v0][v1][v2]|", views: self.nameLabel, self.subHeaderTop, self.subHeaderBottom)
         self.addConstraintsWithFormat(format: "H:|-5-[v0]-5-|", views: self.nameLabel)
        self.addConstraintsWithFormat(format: "H:|-5-[v0]-5-|", views: self.subHeaderTop)
        self.addConstraintsWithFormat(format: "H:|-5-[v0]-5-|", views: self.subHeaderBottom)
    }
}
