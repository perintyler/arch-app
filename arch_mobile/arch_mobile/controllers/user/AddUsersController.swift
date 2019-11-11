//
//  UserCollectionController.swift
//  arch_mobile
//
//  Created by Tyler Perin on 8/13/18.
//  Copyright © 2018 arch. All rights reserved.
//

import Foundation
import UIKit

class SelectableUsersController: UIViewController {
    var groupID: String?
    var selectable: [Selection<User>] = []
    
    let userTable: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.Theme.darkGray
        table.rowHeight = 60.0
        table.register(SelectableUserCell.self, forCellReuseIdentifier: "friendCell")
        return table
    }()
    
    let addFriendsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.Theme.green
        button.layer.cornerRadius = 0
        button.setTitle("Add Friends", for: .normal)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []

//        self.addFriendsButton.addTarget(self, action: #selector(self.add_to_group), for: .touchUpInside)

        self.view.addSubviews(self.userTable, self.addFriendsButton)
        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: self.userTable)
        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: self.addFriendsButton)
        self.view.addConstraintsWithFormat(format: "V:|[v0][v1(50)]|", views: self.userTable, self.addFriendsButton)
        


    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.userTable.dataSource = self
        self.userTable.delegate = self
        
        User.get_friends { users in
            self.selectable = users.map { (user) in Selection<User>(value: user) }
            DispatchQueue.main.async {
                self.userTable.reloadData()
            }
        }
    }
    
    func loadCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SelectableUserCell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! SelectableUserCell
        let user: User = self.selectable[indexPath.row].value
        cell.set(user: user)
        return cell
    }
    


}

extension SelectableUsersController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.selectable.count
        if count == 0 {
            self.userTable.setEmptyMessage("No friends to invite")
        } else {
            self.userTable.restore()
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.loadCell(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: SelectableUserCell = tableView.cellForRow(at: indexPath) as! SelectableUserCell
        let selected = self.selectable[indexPath.row]
        if selected.selected {
            selected.selected = false
            cell.unselect()
        } else {
            selected.selected = true
            cell.select()
        }
    }
    
}



