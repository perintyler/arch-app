/*
 * This file contains an extension for UIKit's UIView class.
 * Functionality included:
 *      - add shadow below view
 *      - Make view rounded
 *      - Make view circular
 *      - Add a gradient background
 */

import Foundation
import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...){
        for view in views {
            self.addSubview(view)
        }
    }
    
    func addBottomShadow(){
        let shadowPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: self.bounds.origin.x, y: self.frame.size.height))
        shadowPath.addLine(to: CGPoint(x: self.bounds.width / 2, y: self.bounds.height + 10.0))
        shadowPath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        shadowPath.close()
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
        self.layer.shadowPath = shadowPath.cgPath
        self.layer.shadowRadius = 4
    }
    
    
    func roundedTopCorners(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft , .topRight],
                                     cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    func makeCircular(){
        self.layer.cornerRadius = self.frame.size.width / 2;
        self.clipsToBounds = true;
    }
    
    func roundCorners(radius: CGFloat){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func addGradient(colors: [UIColor]){
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.frame.size
        gradientLayer.colors = colors.map { (color) -> CGColor in color.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        self.layer.insertSublayer(gradientLayer,at: 0)
    }
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    
    func centerHorizontally(child: UIView) {
        self.addConstraint(NSLayoutConstraint(item: child, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
    }
    
    func centerVertically(child: UIView) {
        self.addConstraint(NSLayoutConstraint(item: child, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    
    func pinTop(_ view: UIView, to relativeView: UIView) {
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: relativeView, attribute: .top, multiplier: 1, constant: 0))
    }
    
    func pinBottom(_ view: UIView, to relativeView: UIView) {
        self.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: relativeView, attribute: .bottom, multiplier: 1, constant: 0))
    }
    
    func addWidthConstraint(_ width: CGFloat, child: UIView) {
        self.addConstraintsWithFormat(format: "H:[v0(\(width))]", views: child)
    }
    
    func addHeightConstraint(_ height: CGFloat, child: UIView) {
        self.addConstraintsWithFormat(format: "V:[v0(\(height))]", views: child)
    }
    
    func fitWidth(subview: UIView) {
        self.addConstraintsWithFormat(format: "H:|[v0]|", views: subview)
    }
    
    func fitHeight(subview: UIView) {
        self.addConstraintsWithFormat(format: "V:|[v0]|", views: subview)
    }
    
    func fit(subview: UIView) {
        self.fitWidth(subview: subview)
        self.fitHeight(subview: subview)
    }
    
}
