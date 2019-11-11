import Foundation
import UIKit

class UserTableDataSource: NSObject {
    var users: [User]!
    
    init(tableView: UITableView, users: [User]) {
        tableView.register(UserCell.self, forCellReuseIdentifier: "user-table-cell")
        self.users = users
    }
    
    private func loadCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserCell = tableView.dequeueReusableCell(withIdentifier: "user-table-cell") as! UserCell
        cell.backgroundColor = UIColor.clear
        let user = self.users[indexPath.row]
        cell.set(user: user)
        return cell
    }
}

extension UserTableDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.users.count
        if(count == 0) {
            tableView.setEmptyMessage("You have no facebook friends on Arch")
        } else {
            tableView.restore()
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.loadCell(tableView, cellForRowAt: indexPath)
    }
    
    
}
