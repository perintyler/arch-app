import Foundation
import UIKit

/*
 TODO: This should inherit headerview instead of gradient view
 */

class GradientHeaderView: GradientView {
    
    let headerView: HeaderView = {
        let header = HeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.setColors(backgroundColor: UIColor.clear, textColor: UIColor.white)
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        self.addSubview(self.headerView)
        
        self.addConstraintsWithFormat(format: "H:|-[v0]|", views: self.headerView)
        self.addConstraintsWithFormat(format: "V:|-25-[v0]-5-|", views: self.headerView)
    }
    
}
