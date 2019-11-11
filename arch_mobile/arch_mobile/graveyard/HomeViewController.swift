//import Foundation
//import UIKit
//import Firebase
//import FacebookLogin
//
//class HomeViewController: TabViewController {
//    
//    let segmentedControl: UISegmentedControl = {
//        let items = ["Events", "Groups"]
//        let segments = UISegmentedControl(items: items)
//        segments.layer.cornerRadius = 0
//        segments.backgroundColor = UIColor.Theme.gray
//        segments.selectedSegmentIndex = 0
//        segments.tintColor = UIColor.Theme.teal
//        segments.translatesAutoresizingMaskIntoConstraints = false
//        segments.removeBorders()
//        return segments
//    }()
//    
////    var groupDataSource: GroupCollectionDataSource!
////    var groupCollection: UICollectionView!
//    
//    var eventCards: CardCollection = {
//        let cards = CardCollection(emptyMessage: "You have no scheduled events")
//        cards.backgroundColor = UIColor.Theme.gray
//        cards.cardCollection.backgroundColor = UIColor.Theme.gray
//        return cards
//    }()
//    
//    let createGroupButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = UIColor.Theme.green
//        button.setTitle("Create Group", for: .normal)
//        button.titleLabel!.textColor = UIColor.black
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.isHidden = true
//        return button
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.edgesForExtendedLayout = []
//        
//        self.view.backgroundColor = UIColor.Theme.gray
//        
//        
//        //segmented controller
//        self.segmentedControl.addTarget(self, action: #selector(self.segmentChange), for: .valueChanged)
//        self.view.addSubviews(views: self.segmentedControl)
//        
//        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: self.segmentedControl)
//        self.view.addConstraintsWithFormat(format: "V:|[v0(50)]", views: self.segmentedControl)
//        
//        
//        //event
//        self.eventCards.cardCollection.delegate = self
//        
//        self.view.addSubview(self.eventCards)
//        
//        self.eventCards.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: self.eventCards)
//        self.view.addConstraintsWithFormat(format: "V:|-50-[v0]|", views: self.eventCards)
//        
//        self.eventCards.add(cardData: Authentication.user.attending)
//        
//        //group collection
//
//        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 10, right: 5)
//        let itemSize = (self.view.frame.width / 3.0) - 25.0 // minus 25 to account for insets
//        layout.itemSize = CGSize(width: itemSize, height: 150)
//        
//        self.groupCollection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
//        self.groupCollection.backgroundColor = UIColor.white
//        self.groupCollection.translatesAutoresizingMaskIntoConstraints = false
//        self.groupCollection.isHidden = true
//        self.groupCollection.backgroundColor = UIColor.Theme.gray
//        
//        db.group.get_all_for_user(id: "\(Authentication.user.id)") { (groups) in
//
//            self.groupDataSource = GroupCollectionDataSource(groups: groups, collection: self.groupCollection, selectionEnabled: false)
//            self.groupDataSource.isDark = true
//
//            DispatchQueue.main.async {
//                self.groupCollection.dataSource = self.groupDataSource
//                self.groupCollection.delegate = self
//                self.groupCollection.reloadData()
//            }
//        }
//        
//        self.view.addSubviews(views: self.createGroupButton, self.groupCollection)
//        self.createGroupButton.addTarget(self, action: #selector(self.goToCreateGroup), for: .touchUpInside)
//        self.view.addConstraintsWithFormat(format: "V:|-50-[v0][v1(50)]|", views: self.groupCollection, self.createGroupButton)
//        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: self.groupCollection)
//        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: self.createGroupButton)
//
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        
//        if let data = eventCards.cardCollection.dataSource as? CardDataSource {
//            DispatchQueue.main.async {
//                data.cardData = Authentication.user.attending
//                self.eventCards.cardCollection.reloadData()
//            }
//        }
//        
//        if let groupDataSource = self.groupDataSource {
//            groupDataSource.reload()
//            self.groupCollection.reloadData()
//        }
//    }
//    
//    
//    @objc func segmentChange() {
//        DispatchQueue.main.async {
//            if(self.segmentedControl.selectedSegmentIndex == 0){
//                self.eventCards.isHidden = false
//                self.groupCollection.isHidden = true
//                self.createGroupButton.isHidden = true
//                
//            } else {
//                self.eventCards.isHidden = true
//                self.groupCollection.isHidden = false
//                self.createGroupButton.isHidden = false
//            }
//        }
//
//    }
//    
//    
//    @objc func goToCreateGroup() {
//        let inputController = InputController()
//        
//        inputController.imageLabel.text = "Add a group image"
//        inputController.imgView.image = UIImage(named: "group-default")
//        inputController.navigationItem.title = "Details"
//        inputController.inputType = "group"
//        inputController.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(inputController, animated: true)
//    }
//    
//}
//
//
//extension HomeViewController: UICollectionViewDelegate {
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if(self.segmentedControl.selectedSegmentIndex == 0) {
//            let eventController = EventController()
//            let eventPreview: Event = self.eventCards.dataSource.cardData[indexPath.row] as! Event
//            eventController.set(eventID: "\(eventPreview.id)")
//            eventController.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(eventController, animated: true)
//        } else {
////            let groupController = GroupController()
////            let group = self.groupDataSource.getGroupForIndexPath(index: indexPath)
////            groupController.set(groupID: "\(group.id)")
////            self.navigationController?.pushViewController(groupController, animated: true)
//        }
//
//    }
//    
//}
