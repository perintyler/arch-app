import Foundation
import UIKit

extension UIViewController {
    
    func show_and_get_indicator() -> UIActivityIndicatorView {
        self.view.isUserInteractionEnabled = false
        
        if let navBar = self.navigationController?.navigationBar {
            navBar.isUserInteractionEnabled = false
        }
        let indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = .whiteLarge
        self.view.addSubview(indicator)
        indicator.startAnimating()
        return indicator
    }
    
    func stop_indicating(indicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            if let navBar = self.navigationController?.navigationBar {
                navBar.isUserInteractionEnabled = true
            }
            indicator.stopAnimating()
            indicator.removeFromSuperview()
        }

    }

}
