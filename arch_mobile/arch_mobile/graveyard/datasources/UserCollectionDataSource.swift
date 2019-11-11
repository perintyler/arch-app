//import Foundation
//import UIKit
//
///*
// * This class can be used as a data source for a uicollectionview. It uses a given list of
// * User objects to populate the collection with cells which look like a group cell, but
// * uses user images and names instead of group's. Right now, this is only used to make
// * users card
// */
//class UserCollectionDataSource: NSObject {
//    var selectable: [Selection<User>]!
//    
//    init(users: [User], collection: UICollectionView, emptyMessage: String?, selectable: Bool){
//        self.selectable = users.map { (user) -> Selection<User> in
//            return Selection(value: user)
//        }
//        collection.register(GroupCell.self, forCellWithReuseIdentifier: "imageTextCell")
//    }
//    
//    func getSelected() -> [User] {
//        var selected: [User] = []
//        for user in selectable {
//            selected.append(user.value)
//        }
//        return selected
//    }
//    
//    func loadCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell : ImageAndTextCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageTextCell", for: indexPath) as! GroupCell
//        let user = self.selectable[indexPath.row].value
//        cell.set(imageUrlStr: Facebook.getPictureUrl(id: user.facebookID), text: user.name)
//        return cell
//    }
//}
//
//
//extension UserCollectionDataSource: UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        return self.loadCell(collectionView, cellForItemAt: indexPath)
//    }
//    
//    
//}
