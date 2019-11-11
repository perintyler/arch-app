//
//  SelectableUserCell.swift
//  arch_mobile
//
//  Created by Tyler Perin on 8/13/18.
//  Copyright © 2018 arch. All rights reserved.
//

import Foundation
import UIKit

class SelectableUserCell: UserCell {
    
    let selectedView: UIView = {
        let size: CGFloat = 32.0
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.Theme.lightGray
        view.layer.borderColor = UIColor.Theme.gray.cgColor
        view.layer.borderWidth = 2.0
        view.layer.cornerRadius = size / 2.0
        view.clipsToBounds = true
        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.Theme.gray
        self.selectionStyle = .none
        self.addSubview(self.selectedView)
        self.addConstraintsWithFormat(format: "H:[v0(32)]-15-|", views: self.selectedView)
        self.addConstraintsWithFormat(format: "V:[v0(32)]", views: self.selectedView)
        self.centerVertically(child: self.selectedView)
    }
    
    func select() {
        DispatchQueue.main.async {
            self.selectedView.backgroundColor = UIColor.Theme.blue
        }
    }
    
    func unselect() {
        DispatchQueue.main.async {
            self.selectedView.backgroundColor = UIColor.white
        }
    }
    
}
