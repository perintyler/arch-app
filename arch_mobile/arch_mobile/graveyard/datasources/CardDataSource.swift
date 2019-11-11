//import Foundation
//import UIKit
//
//class CardDataSource: NSObject {
//    var headerType: String!
//    var venue: Venue?
//    var event: Event?
//    var emptyMessage: String?
//    var cardData: [CardModel] = []
//    
//    
//    init(collection: UICollectionView){
//        collection.register(CardCell.self, forCellWithReuseIdentifier: "cardCell")
//    }
//    
//    init(collection: UICollectionView, emptyMessage: String) {
//        self.emptyMessage = emptyMessage
//        collection.register(CardCell.self, forCellWithReuseIdentifier: "cardCell")
//    }
//    
//    func loadCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell: CardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCell
//        
//        DispatchQueue.main.async {
//            cell.set(cardModel: self.cardData[indexPath.row])
//        }
//        
//        return cell
//    }
//    
//    func add(cardData: CardModel) {
//        self.cardData.append(cardData)
//    }
//}
//
//extension CardDataSource: UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let count = self.cardData.count
//        if let empty_message = self.emptyMessage {
//            if(count == 0) {
//                DispatchQueue.main.async {
//                    collectionView.setEmptyMessage(empty_message)
//                }
//            } else {
//                DispatchQueue.main.async {
//                    collectionView.restore()
//                }
//            }
//        }
//        return self.cardData.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        return self.loadCell(collectionView, cellForItemAt: indexPath)
//    }
//    
//}
