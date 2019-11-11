//import Foundation
//import UIKit
//
//class GroupCollectionController: UIViewController {
//    var groupMins: [GroupPreview] = []
//    
//    var groupCollection: UICollectionView!
//    
//    override func viewWillAppear(_ animated: Bool) {
//        db.group.get_all_for_user(id: "\(Authentication.user.id)") { (groups) in
//            self.groupMins = groups
//            
//            DispatchQueue.main.async {
//                self.groupCollection.reloadData()
//            }
//        }
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//        
//        let itemSize = (self.view.frame.width / 3.0) - 10.0 // minus 10 to account for insets
//        layout.itemSize = CGSize(width: itemSize, height: 150)
//        self.groupCollection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
//        self.groupCollection.backgroundColor = UIColor.white
//        self.groupCollection.register(GroupCell.self, forCellWithReuseIdentifier: "groupCell")
//        self.groupCollection.translatesAutoresizingMaskIntoConstraints = false
//        
//        
//        self.navigationItem.title = "Groups"
//        self.edgesForExtendedLayout = []
//        self.view.backgroundColor = UIColor.white
//
//        self.groupCollection.dataSource = self
//        self.groupCollection.delegate = self
//        
//        self.view.addSubview(groupCollection)
//
//        self.view.addConstraintsWithFormat(format: "V:|[v0]|", views: self.groupCollection)
//        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: self.groupCollection)
//        
//    }
//    
//    func loadCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell : GroupCell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupCell",
//                                                                  for: indexPath) as! GroupCell
//        cell.set(group: self.groupMins[indexPath.row])
//        return cell
//    }
//    
//}
//
//
//extension GroupCollectionController: UICollectionViewDataSource, UICollectionViewDelegate {
//    
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return 3
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let groupCount = self.groupMins.count
//        if(groupCount == 0) {
//            collectionView.setEmptyMessage("You have no groups")
//        } else {
//            collectionView.restore()
//        }
//        return self.groupMins.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        return self.loadCell(collectionView, cellForItemAt: indexPath)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedGroup = self.groupMins[indexPath.row]
//        let groupController = GroupController()
//        groupController.set(groupPreview: selectedGroup)
//        self.navigationController?.pushViewController(groupController, animated: true)
//    }
//
//}
//
