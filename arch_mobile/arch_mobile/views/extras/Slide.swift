//
//  Slide.swift
//  arch_mobile
//
//  Created by Camilla Moraes on 9/9/18.
//  Copyright © 2018 arch. All rights reserved.
//

import UIKit

class Slide: UIView {
    
    let header: UILabel = {
        let header = UILabel()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.font = UIFont.Theme.mediumTitleLabel
        header.textColor = UIColor.init(red: 159/255, green: 170/255, blue: 170/255, alpha: 1)
        return header
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let details: UILabel = {
        let details = UILabel()
        details.translatesAutoresizingMaskIntoConstraints = false
        details.font = UIFont.Theme.detailsLabel
        details.textColor = UIColor.white
        details.numberOfLines = 5
        details.lineBreakMode = .byWordWrapping
        return details
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(header)
        self.addSubview(imageView)
        self.addSubview(details)
        
        self.clipsToBounds = true
        let screen_width = UIScreen.main.bounds.width
        let top_margin = screen_width * 0.15
        let image_width = screen_width * 0.5
        
        self.addConstraintsWithFormat(format: "V:|-\(top_margin)-[v0]-40-[v1(\(image_width))]-40-[v2]|", views: self.header, self.imageView, self.details)
        self.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: self.details)
        self.addWidthConstraint(image_width, child: self.imageView)
        self.centerHorizontally(child: self.header)
        self.centerHorizontally(child: self.imageView)
        
    }
    
    
}
