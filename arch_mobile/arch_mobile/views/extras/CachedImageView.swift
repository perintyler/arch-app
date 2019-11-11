import Foundation
import UIKit

class CachedImageView: UIImageView {
    
    static var cache = NSCache<NSString, UIImage>()
    
    func load(urlStr: String) {
        if let cachedImage = CachedImageView.cache.object(forKey: urlStr as NSString) {
            DispatchQueue.main.async {
                self.image = cachedImage
            }
        } else {
            let url = URL(string: urlStr)!
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    let downloadedImage = UIImage(data: data)
                    self.image = downloadedImage
                    CachedImageView.cache.setObject(downloadedImage!, forKey: urlStr as NSString)
                }
            }.resume()
        }
    }
    
    func load(path: String, file_name: String) {
        download_image(path: path, file_name: file_name) { downloaded_image in
            self.image = downloaded_image
        }
    }
    
}
