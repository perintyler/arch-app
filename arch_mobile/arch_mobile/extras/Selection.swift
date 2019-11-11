//
//  Selection.swift
//  arch_mobile
//
//  Created by Tyler Perin on 7/28/18.
//  Copyright © 2018 arch. All rights reserved.
//

import Foundation

class Selection<T> {
    var selected: Bool
    var value: T
    
    init(value: T){
        self.selected = false
        self.value = value
    }
}
