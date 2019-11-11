//import Foundation
//import UIKit
//
//class UsersCard: Card {
//    
//    let userCollection: UICollectionView = UICollectionView()
//    
//    override init(frame: CGRect){
//        super.init(frame: frame)
//        self.setupViews()
//    }
//    
//    convenience init(){
//        self.init(frame: CGRect.zero)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    func set(users: [User]) {
//        let dataSource = UserCollectionDataSource(users: users, collection: self.userCollection, emptyMessage: nil, selectable: false)
//        self.userCollection.dataSource = dataSource
//    }
//    
//    private func setupViews(){
//        self.addConstraintsWithFormat(format: "H:|-5-[v0]-5-|", views: self.userCollection)
//        self.addConstraintsWithFormat(format: "V:|-5-[v0]-5-|", views: self.userCollection)
//        self.addSubview(self.userCollection)
//    }
//}
