//
//  ImageView.swift
//  arch_mobile
//
//  Created by Tyler Perin on 7/28/18.
//  Copyright © 2018 arch. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func set(urlStr: String){
        let url = URL(string: urlStr)!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() {
                self.image = UIImage(data: data)
            }
        }.resume()

    }
    
    public func loadGif(name: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    @available(iOS 9.0, *)
    public func loadGif(asset: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(asset: asset)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
