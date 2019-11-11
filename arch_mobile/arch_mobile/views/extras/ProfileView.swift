import Foundation
import UIKit

class ProfileView: UIView {
    
    static let height: CGFloat = 300.0
    var cachable: Bool
    
    var gradientHeaderView: GradientHeaderView = {
        let gradientHeader = GradientHeaderView()
        gradientHeader.headerView.setColors(backgroundColor: UIColor.clear, textColor: UIColor.white)
        return gradientHeader
    }()
    
    let imgView: CachedImageView = {
        let coverImageView = CachedImageView()
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        return coverImageView
    }()
    

    init(frame: CGRect, cachable: Bool = false){
        self.cachable = cachable
        super.init(frame: frame)
        self.setupViews()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    convenience init(cachable: Bool) {
        self.init(frame: CGRect.zero, cachable: cachable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.cachable = false
        super.init(coder: aDecoder)
    }
    
    func setImage(urlStr: String){
        if(self.cachable == true) {
            self.imgView.load(urlStr: urlStr)
        }else {
            self.imgView.set(urlStr: urlStr)
        }
    }
    
    func setImage(assetName: String){
        self.imgView.image = UIImage(named: assetName)
    }
    
    func setHeader(name: String, descTop: String, descBottom: String){
        self.gradientHeaderView.headerView.setLabels(name: name, descTop: descTop, descBottom: descBottom)
    }
    
    func setMainHeader(name: String) {
        self.gradientHeaderView.headerView.setMainHeader(text: name)
    }
    
    func setSubHeaders(top: String, bottom: String) {
        self.gradientHeaderView.headerView.setTopSubHeader(text: top)
        self.gradientHeaderView.headerView.setBottomSubHeader(text: bottom)
    }
    
    private func setupViews(){
        self.addSubviews(self.gradientHeaderView, self.imgView)
        self.bringSubview(toFront: self.gradientHeaderView)
        
        self.addConstraintsWithFormat(format: "H:|[v0]|", views:  self.imgView)
        self.addConstraintsWithFormat(format: "H:|[v0]|", views: self.gradientHeaderView)
        self.addConstraintsWithFormat(format: "V:|[v0]|", views: self.imgView)
        self.addConstraintsWithFormat(format: "V:|-135-[v0]|", views: self.gradientHeaderView)
    }
    
}
