import Foundation
import UIKit

class GradientView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        self.image = UIImage(named: "gradient")
//        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
}
