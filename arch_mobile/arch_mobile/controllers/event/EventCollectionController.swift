import Foundation
import UIKit

class EventTableController: TabViewController {
    
    var events: [Event] = []
    var eventTable: UITableView!
//    var eventCards: CardCollection = {
//        let cards = CardCollection(emptyMessage: "No Scheduled Events")
//        cards.backgroundColor = UIColor.Theme.gray
//        cards.cardCollection.backgroundColor = UIColor.Theme.gray
//        return cards
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup_event_collection()
        
        Event.get_attending { events in
            self.events = events
            
            DispatchQueue.main.async {
                self.eventTable.reloadData()
            }
        }

    }
    
    private func setup_event_collection() {
        
        self.eventTable = UITableView(frame: self.view.frame)
        
        self.view.addSubview(self.eventTable)

        self.eventTable.backgroundColor = UIColor.Theme.gray
        
//        self.eventTable.register(EventCell.self, forCellWithReuseIdentifier: "eventCell")
        self.eventTable.dataSource = self
        self.eventTable.delegate = self

        
    }

    
}

extension EventTableController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventCell: EventCell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventCell
        let event = self.events[indexPath.row]
        eventCell.backgroundColor = UIColor.red
        eventCell.set(event)
        return eventCell
    }
    
    
    private func tableView(_ tableView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let eventController = EventController()
        
        let event: Event = self.events[indexPath.row]
        eventController.set(event)
        
        eventController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(eventController, animated: true)
    }
    
    
}
