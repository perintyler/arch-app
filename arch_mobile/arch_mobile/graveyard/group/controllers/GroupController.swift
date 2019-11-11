////
////  GroupController.swift
////  arch_mobile
////
////  Created by Tyler Perin on 7/27/18.
////  Copyright © 2018 arch. All rights reserved.
////
//
//
//import Foundation
//import UIKit
//
//class GroupController : UIViewController {
//    
//    var groupID: String?
//    
//    var group: GroupPreview!
//    var users: [UserPreview] = []
//    
//    
//    let imgView: UIImageView = {
//        let profile = UIImageView()
//        profile.translatesAutoresizingMaskIntoConstraints = false
//        profile.contentMode = .scaleAspectFill
//        return profile
//    }()
//    
//    let labelView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.Theme.darkGray
//        return view
//    }()
//    
//    let nameLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = UIColor.white
//        label.font = UIFont.Theme.headerSmall
//        return label
//    }()
//    
//    let userTable: UITableView = {
//        let table = UITableView()
//        table.translatesAutoresizingMaskIntoConstraints = false
//        table.backgroundColor = UIColor.white
//        table.rowHeight = 60.0
//        table.register(UserCell.self, forCellReuseIdentifier: "userTableCell")
//        return table
//    }()
//    
//    let inviteButton: UIButton = {
//        let button = UIButton()
//        button.layer.cornerRadius = 0.0
//        button.backgroundColor = UIColor.Theme.green
//        button.setTitle("Add Friends", for: .normal)
//        return button
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        if let group_pk = self.groupID {
//            self.set(groupID: group_pk)
//        }
//        
//        let leaveGroupButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.leaveGroup))
//        self.navigationItem.rightBarButtonItem = leaveGroupButton
//        self.navigationController?.navigationBar.tintColor = UIColor.white
//        
//        self.view.backgroundColor = UIColor.white
//        self.edgesForExtendedLayout = []
//
//        self.userTable.dataSource = self
//        self.inviteButton.addTarget(self, action: #selector(self.addFriends), for: .touchUpInside)
//        
//        self.view.addSubviews(views: self.imgView, self.labelView, self.userTable, self.inviteButton)
//
//        self.view.addConstraintsWithFormat(format: "V:|[v0(200)][v1(50)][v2][v3(50)]|", views: self.imgView, self.labelView, self.userTable, self.inviteButton)
//        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: self.inviteButton)
//        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: self.imgView)
//        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: self.labelView)
//        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: self.userTable)
//        
//        self.labelView.addSubview(self.nameLabel)
//        self.labelView.addConstraintsWithFormat(format: "H:|-15-[v0]", views: self.nameLabel)
//        self.labelView.centerVertically(child: self.nameLabel)
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        if(self.group != nil) {
//            self.userTable.reloadData()
//        }
//    }
//    
//    func set(groupID: String) {
//        let id = "\(groupID)"
//        
//        db.group.get(id: id) { (group) in
//            self.group = GroupPreview(id: group.id, name: group.name, imgStr: group.imgUrlStr)
//            if let imgStr = group.imgUrlStr {
//                self.imgView.set(urlStr: imgStr)
//            } else {
//                DispatchQueue.main.async {
//                    self.imgView.image = UIImage(named: "group-default")
//                }
//            }
//            
//            DispatchQueue.main.async {
//                self.nameLabel.text = group.name
//                
//                self.users = group.users
//                self.userTable.reloadData()
//            }
//        }
//    }
//    
//    func set(groupPreview: GroupPreview) {
//        self.group = groupPreview
//        DispatchQueue.main.async {
//            if let imgStr = groupPreview.imgUrlStr {
//                self.imgView.set(urlStr: imgStr)
//            } else {
//                self.imgView.image = UIImage(named: "group-default")
//            }
//            
//            self.nameLabel.text = groupPreview.name
//        }
//
//        
//    
//        db.group.get(id: "\(groupPreview.id)") { (group) in
//            DispatchQueue.main.async() {
//                self.users = group.users
//                self.userTable.reloadData()
//            }
//        }
//    }
//    
//    func loadCell(atIndexPath indexPath: IndexPath, forTableView tableView: UITableView) -> UITableViewCell {
//        let cell: UserCell = tableView.dequeueReusableCell(withIdentifier: "userTableCell", for: indexPath) as! UserCell
//        cell.selectionStyle = .none
//        let user = self.users[indexPath.row]
//        cell.set(user: user)
//        return cell
//    }
//    
//    @objc func addFriends(){
//        let userCollectionController = AddUsersController()
//        userCollectionController.groupID = "\(self.group.id)"
//        self.navigationController?.pushViewController(userCollectionController, animated: true)
//    }
//    
//    @objc func leaveGroup(){
//        let alertController = UIAlertController(title: "Leave Group",message: "Are you sure you want to leave this group?", preferredStyle: .alert)
//        
//        let yesAction = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
//            db.group.leave(groupID: "\(self.group.id)", userID: "\(Authentication.user.id)"){ () in
//                DispatchQueue.main.async {
//                    self.navigationController?.popToRootViewController(animated: true)
//                }
//            }
//        }
//        
//        alertController.addAction(yesAction)
//        
//        let noAction = UIAlertAction(title: "No", style: .cancel)
//        alertController.addAction(noAction)
//
//        self.present(alertController,animated: true, completion: nil)
//    }
//    
//    
//    
//}
//
//extension GroupController: UITableViewDataSource {
//    
//        func numberOfSections(in tableView: UITableView) -> Int {
//            return 1
//        }
//    
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return self.users.count
//        }
//    
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            return self.loadCell(atIndexPath: indexPath, forTableView: tableView)
//        }
//    
//}
//
