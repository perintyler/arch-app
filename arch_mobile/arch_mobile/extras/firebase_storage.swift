//
//  Storage.swift
//  arch_mobile
//
//  Created by Tyler Perin on 8/11/18.
//  Copyright © 2018 arch. All rights reserved.
//

import Foundation
import Firebase
import UIKit

let bucket = "gs://arch-b83e2.appspot.com"


func upload_image(_ image: UIImage, path: String, file_name: String) {
    
    if let data = image.jpeg(.medium) {
        let storage = Storage.storage(url: bucket)
        let image_ref = storage.reference().child(path).child(file_name)

        DispatchQueue.main.async {
            image_ref.putData(data,metadata:nil,completion: {(metaData,error) in
                image_ref.downloadURL(completion: {(url,error) in return })
            })
        }
    }
}

func download_image(path: String, file_name: String, callback: @escaping (UIImage)->()) {
    
    let max_size: Int64 = 1 * 2048 * 2048

    let storage = Storage.storage(url: bucket)
    let image_ref = storage.reference().child(path).child(file_name)
    image_ref.getData(maxSize: max_size) { data, error in
        if let error = error { print(error) }
        else { callback(UIImage(data: data!)!) }
    }
}

