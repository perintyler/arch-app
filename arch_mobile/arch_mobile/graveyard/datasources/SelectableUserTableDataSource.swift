//import Foundation
//import UIKit
//
//class SelectableUserTableDataSource: NSObject {
//    var selectable: [Selection<User>]!
//    init(tableView: UITableView, users: [User]) {
//        tableView.register(SelectableUserCell.self, forCellReuseIdentifier: "selectableUserCell")
//        self.selectable = users.map { (user) in
//            return Selection<User>(value: user)
//        }
//    }
//    
//    func getSelected() -> [User] {
//        var selected: [User] = []
//        for user in selectable {
//            if(user.selected == true){
//                selected.append(user.value)
//            }
//        }
//        return selected
//    }
//    
//    private func loadCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: SelectableUserCell = tableView.dequeueReusableCell(withIdentifier: "selectableUserCell") as! SelectableUserCell
//        let user = self.selectable[indexPath.row].value
//        cell.set(user: user)
//        cell.backgroundColor = UIColor.clear
//        if(self.selectable[indexPath.row].selected) {
//            cell.select()
//        } else {
//            cell.unselect()
//        }
//        return cell
//    }
//}
//
//extension SelectableUserTableDataSource: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let count = self.selectable.count
//        if(count == 0) {
//            tableView.setEmptyMessage("You have no facebook friends on Arch")
//        } else {
//            tableView.restore()
//        }
//        return count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return self.loadCell(tableView, cellForRowAt: indexPath)
//    }
//    
//}
//
//extension SelectableUserTableDataSource: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell: SelectableUserCell = tableView.cellForRow(at: indexPath) as! SelectableUserCell
//        let selection = self.selectable[indexPath.row]
//        if(selection.selected == true) {
//            cell.unselect()
//            selection.selected = false
//        } else {
//            selection.selected = true
//            cell.select()
//        }
//    }
//}
