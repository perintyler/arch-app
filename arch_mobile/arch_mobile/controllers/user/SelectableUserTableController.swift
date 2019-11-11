import Foundation
import UIKit

class SelectableUserTableController: UIViewController {
    
    var groupID: String?
    var selectables: [Selection<User>]!
    var event: Event!
    
    let userTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = UIColor.Theme.gray
        table.rowHeight = 100.0
        table.register(SelectableUserCell.self, forCellReuseIdentifier: "friendCell")
        table.tableFooterView = UIView()
        return table
    }()
    
    let inviteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.Theme.green
        button.layer.cornerRadius = 0
        button.setTitle("Invite Friends", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Invite Friends"
        self.edgesForExtendedLayout = []
        
        self.inviteButton.addTarget(self, action: #selector(self.invite_to_event), for: .touchUpInside)
        
        self.view.addSubviews(self.userTable, self.inviteButton)
        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: self.userTable)
        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: self.inviteButton)
        self.view.addConstraintsWithFormat(format: "V:|[v0][v1(70)]|", views: self.userTable, self.inviteButton)
    }
    
    @objc func invite_to_event() {
        var users_to_invite: [User] = [] //fb ids of friends to invite
        for selectable in self.selectables {
            if(selectable.selected == true){
                users_to_invite.append(selectable.value)
            }
        }
        self.event.invite(users_to_invite)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        User.get_friends { users in
            self.selectables = users.map { (user) in Selection<User>(value: user) }
            DispatchQueue.main.async {
                self.userTable.dataSource = self
                self.userTable.delegate = self
                self.userTable.reloadData()
            }
        }
    }
    
    
}

extension SelectableUserTableController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.selectables.count
        if count == 0 {
            self.userTable.setEmptyMessage("No friends to invite")
        } else {
            self.userTable.restore()
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SelectableUserCell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! SelectableUserCell
        let selectable = self.selectables[indexPath.row]
        let user: User = selectable.value
        cell.set(user: user)
        
        if selectable.selected {
            cell.select()
        } else {
            cell.unselect()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: SelectableUserCell = tableView.cellForRow(at: indexPath) as! SelectableUserCell
        let selected = self.selectables[indexPath.row]
        if selected.selected {
            cell.unselect()
            selected.selected = false
        } else {
            cell.select()
            selected.selected = true
        }
    }
    
}


