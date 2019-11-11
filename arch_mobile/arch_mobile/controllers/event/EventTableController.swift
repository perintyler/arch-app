import Foundation
import UIKit

class EventTableController: TabViewController {
    
    var events: [Event]!
    var eventTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Theme.gray
        
        self.setup_event_collection()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let dataSourceNotSet = self.eventTable.dataSource == nil || self.eventTable.delegate == nil
        var indicator: UIActivityIndicatorView? = nil
        
        if dataSourceNotSet {
            indicator = self.show_and_get_indicator()
        }
        
        Event.get_attending { updated_events in
            self.events = updated_events
            
            DispatchQueue.main.async {
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.user_event_dates = self.events.map { event in event.get_date() }
                
                if dataSourceNotSet {
                    self.eventTable.dataSource = self
                    self.eventTable.delegate = self
                    self.stop_indicating(indicator: indicator!)
                }
                self.eventTable.reloadData()
            }
        }
    }
    
    private func setup_event_collection() {
        
        self.eventTable = UITableView(frame: self.view.frame)
        self.eventTable.backgroundColor = UIColor.Theme.gray
        self.eventTable.tableFooterView = UIView()
        self.eventTable.rowHeight = EventCell.height
        self.view.addSubview(self.eventTable)
        
        self.eventTable.register(EventCell.self, forCellReuseIdentifier: "eventCell")
    }
    
    
}

extension EventTableController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.events.count
        if count == 0 {
            tableView.setEmptyMessage("You have no upcoming events")
        } else {
            tableView.restore()
        }
        return self.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventCell: EventCell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventCell
        let event = self.events[indexPath.row]
        eventCell.set(event)
        return eventCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event: Event = self.events[indexPath.row]
        
        if event.expired == false {
            let eventController = EventController()
            
            eventController.event = event
            
            eventController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(eventController, animated: true)
        }
    }
    
    
}
