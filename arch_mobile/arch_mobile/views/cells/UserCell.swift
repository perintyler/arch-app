//
//  UserCell.swift
//  arch_mobile
//
//  Created by Tyler Perin on 7/27/18.
//  Copyright © 2018 arch. All rights reserved.
//

import Foundation
import UIKit


class UserCell: ImageAndTextTableCell {
    
    
    func set(user: User){
        self.set(imgUrlStr: user.get_image_url(), text: user.name)
    }

}
