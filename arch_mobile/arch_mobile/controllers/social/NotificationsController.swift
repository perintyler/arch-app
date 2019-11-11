import Foundation
import UIKit

class NotificationController: UIViewController {
    
    var notifications: [Notification] = []
    var notificationTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(NotificationCell.self, forCellReuseIdentifier: "notifCell")
        table.rowHeight = 100.0
        table.backgroundColor = UIColor.Theme.gray
        table.tableFooterView = UIView()
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.view.backgroundColor = UIColor.Theme.gray
        
        self.view.addSubviews(self.notificationTable)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.notificationTable.frame = self.view.bounds
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        let indicator = self.show_and_get_indicator()
        
        Notification.get_all { (notifs) in
            self.notifications = notifs
            //Authentication.user.notifCount = 0
            DispatchQueue.main.async {
                // set unread notifications to 0 in app data
                (UIApplication.shared.delegate as! AppDelegate).unread_notifs = 0
                
                self.notificationTable.dataSource = self
                self.notificationTable.delegate = self
                self.notificationTable.reloadData()
                
                self.stop_indicating(indicator: indicator)
            }
        }
    }
    
    
}


extension NotificationController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.notifications.count
        if(count == 0) {
            self.notificationTable.setEmptyMessage("You have no notifications")
        } else {
            self.notificationTable.restore()
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : NotificationCell = tableView.dequeueReusableCell(withIdentifier: "notifCell", for: indexPath) as! NotificationCell
        let notification = self.notifications[indexPath.row]
        cell.set(notification)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notif = self.notifications[indexPath.row]
       
        if notif.accepted {
            let eventController = EventController()
            eventController.event = notif.event
            self.navigationController?.pushViewController(eventController, animated: true)
        } else {
            let prompt_message = "Join event on \(notif.event.get_date().formatted())"
            let alert = UIAlertController(title: "Join Event", message: prompt_message, preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "yes", style: .default, handler: { action in
                notif.event.attend()
                let eventController = EventController()
                eventController.event = notif.event
                self.navigationController?.pushViewController(eventController, animated: true)
            })

            let noAction = UIAlertAction(title: "no", style: .default, handler: nil)
            alert.addAction(yesAction)
            alert.addAction(noAction)

            self.present(alert,animated: true, completion: nil)

            
        }
    }
    
}
