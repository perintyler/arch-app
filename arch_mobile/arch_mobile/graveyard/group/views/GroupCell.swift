//import Foundation
//import UIKit
//
//
//class GroupCell: ImageAndTextCell {
//    
//    override init(frame: CGRect){
//        super.init(frame: frame)
//        self.setupViews()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.setupViews()
//    }
//    
//    convenience init(){
//        self.init(frame: CGRect.zero)
//    }
//    
//    func set(group: GroupPreview){
//        //set image for group if there is one, otherwise set the default group image
//        if let imgStr = group.imgUrlStr {
//            self.set(imageUrlStr: imgStr, text: group.name)
//        }else{
//            self.set(staticImageName: "group-default")
//            self.set(text: group.name)
//        }
//
//    }
//    
//    func select(){
//        DispatchQueue.main.async {
//            self.layer.borderWidth = 3.0
//            self.label.font = UIFont.boldSystemFont(ofSize: 17)
//        }
//    }
//    
//    func unselect(){
//        DispatchQueue.main.async {
//            self.layer.borderWidth = 0
//            self.label.font = UIFont.systemFont(ofSize: 17)
//        }
//    }
//    
//    func turnDark() {
//        self.label.textColor = UIColor.white
//        self.imgView.backgroundColor = UIColor.white
//    }
//    
//    private func setupViews(){
//        self.layer.borderColor = UIColor.Theme.lightBlue.cgColor
//        self.layer.cornerRadius = 4
//    }
//
//}
