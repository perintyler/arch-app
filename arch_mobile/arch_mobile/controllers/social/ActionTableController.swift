import Foundation
import UIKit
import Firebase
import FacebookLogin

/*
 * The stream controller is created after login, and is a home screen tab.
 * The stream controller display 'stream items' which displays the user's
 * friends' activity, such as joining or creating an event. The stream
 * items are populated by making a api call to the users stream endpoint.
 * Paginated api calls are made to minimize the amount of data being
 * requested.
 */
class ActionTableController: TabViewController {
    
    var friend_actions: [Action] = []
    
    let streamTable: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.Theme.gray
        tableView.register(ActionCell.self, forCellReuseIdentifier: "streamItemCell")
        tableView.rowHeight = 105
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Theme.gray
        self.view.addSubview(self.streamTable)
        
        //add stream table to view and configure constraints
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.streamTable.frame = self.view.frame
        
        //make call to users stream endpoint to get stream items, then reload table data
        Action.get_all() { (items) in
            self.friend_actions = items
            DispatchQueue.main.async {
                //set stream table data source (no delegate)
                self.streamTable.dataSource = self
                self.streamTable.reloadData()
            }
        }
    }
    
}

extension ActionTableController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.friend_actions.count
        if(count == 0) {
            self.streamTable.setEmptyMessage("No Friend Activity")
        } else {
            self.streamTable.restore()
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ActionCell = tableView.dequeueReusableCell(withIdentifier: "streamItemCell", for: indexPath) as! ActionCell
        let action = self.friend_actions[indexPath.row]
        cell.set(action)
        return cell
    }
    
}
