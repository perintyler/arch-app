import Foundation
import UIKit

class UserTableController: UIViewController {
    var emptyMessage: String?
    var event: Event!
    var userMins: [User]!
    
    var table: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.Theme.gray
        tableView.register(UserCell.self, forCellReuseIdentifier: "userCell")
        tableView.rowHeight = 80.0
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Attendance"
        self.view.addSubview(self.table)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.table.frame = self.view.frame
        
        self.event.get_attending { users in
            self.userMins = users
            
            DispatchQueue.main.async {
                self.table.dataSource = self
                self.table.reloadData()
            }
        }
        
    }
    
    func set(userMins: [User]) {
        self.userMins = userMins
        self.table.reloadData()
    }
    
    private func loadCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserCell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserCell
        let user = self.userMins[indexPath.row]
        cell.imgView.set(urlStr: user.get_image_url())
        cell.label.text = user.name
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.Theme.gray
        return cell
    }
}


extension UserTableController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let userCount = self.userMins.count
        if(userCount == 0 && self.emptyMessage != nil) {
            self.table.setEmptyMessage(self.emptyMessage!)
        } else {
            self.table.restore()
        }
        return userCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.loadCell(tableView, cellForRowAt: indexPath)
    }
    
    
}
