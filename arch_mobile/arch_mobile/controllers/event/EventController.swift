import Foundation
import UIKit
import CoreLocation

class EventController: UIViewController {
    
    var event: Event!
    var locationManager: CLLocationManager!
 
    var venueLocation: CLLocation! // used for checking in
    
    var info_table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = [.top]
        
        self.setup_navbar_buttons()
        self.setup_info_collection()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.info_table.frame = self.view.frame
        
        self.info_table.dataSource = self
        self.info_table.delegate = self
    }
    
    private func setup_info_collection() {
        // create the table
        self.info_table = UITableView()
        
        // add the table to the superview
        self.view.addSubviews(self.info_table)
        
        self.info_table.translatesAutoresizingMaskIntoConstraints = false
        self.info_table.backgroundColor = UIColor.Theme.gray
        self.info_table.separatorStyle = .none
        
        // registre all the cells used in the entire table
        self.info_table.register(EventCell.self, forCellReuseIdentifier: "eventCell")
        self.info_table.register(SplitButtonCell.self, forCellReuseIdentifier: "splitButtonCell")
        self.info_table.register(NextDiscountCell.self, forCellReuseIdentifier: "nextDiscountCell")
        self.info_table.register(DescriptionCell.self, forCellReuseIdentifier: "paragraphCell")
        self.info_table.register(VenueCell.self, forCellReuseIdentifier: "venueCell")
    }
    
    private func setup_navbar_buttons() {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let newBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.go_back))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        let optionsButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.openOptions))
        self.navigationItem.rightBarButtonItem = optionsButton
    }
    
    
}

extension EventController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.event.desc != nil ? 5 : 4)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let collection_width = self.info_table.frame.width
        
        let header_height: CGFloat = EventCell.height
        let buttonsCellHeight: CGFloat = 90.0
        let nextDiscountCellHeight: CGFloat = 90.0
        let desription_height: CGFloat = DescriptionCell.get_height(text: self.event.venue.desc, width: collection_width)
        let map_height: CGFloat = 300.0
        
        switch indexPath.row {
            // header cell: venue picture, name, and main info, and buttons
            case 0: return header_height
            // paragraph cell: venue description
            case 1: return buttonsCellHeight
            case 2: return nextDiscountCellHeight
            case 3: return (self.event.desc != nil ? desription_height : map_height)
            // map cell: venue location
            default: return map_height
        }
    }
    
}

extension EventController {
    
    @objc func go_back() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            case 0: return self.get_event_cell(indexPath)
            case 1: return self.get_split_button_cell(indexPath)
            case 2: return self.get_next_discount_cell(indexPath)
            case 3: return self.event.desc != nil ? self.get_paragraph_cell(indexPath) : self.get_venue_cell(indexPath)
            default: return self.get_venue_cell(indexPath)
        }
    }
    
    func get_event_cell(_ indexPath: IndexPath) -> UITableViewCell {
        let eventCell: EventCell = self.info_table.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventCell
        eventCell.set(self.event)

        // add target to attendance button
        eventCell.setAttendAction(action: #selector(self.goToAttendance), target: self)
        
        return eventCell
    }
    
    func get_split_button_cell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell: SplitButtonCell = self.info_table.dequeueReusableCell(withIdentifier: "splitButtonCell", for: indexPath) as! SplitButtonCell
        cell.buttonA.addTarget(self, action: #selector(self.inviteFriends), for: .touchUpInside)
        cell.buttonB.addTarget(self, action: #selector(self.claim_discounts), for: .touchUpInside)
        
        cell.setColors(colorA: UIColor.Theme.orange, colorB: UIColor.Theme.green)
        cell.setTitles(titleA: "Invite Friends", titleB: "Claim Discounts")
        return cell
    }
    
    func get_next_discount_cell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell: NextDiscountCell = self.info_table.dequeueReusableCell(withIdentifier: "nextDiscountCell", for: indexPath) as! NextDiscountCell
        
        self.event.get_next_discount { discount in
            DispatchQueue.main.async {
                cell.set(discount)
            }
        }
        return cell

    }
    func get_paragraph_cell(_ indexPath: IndexPath) -> UITableViewCell {
        let paragraphCell: DescriptionCell = self.info_table.dequeueReusableCell(withIdentifier: "paragraphCell", for: indexPath) as! DescriptionCell
        paragraphCell.set(self.event.desc!!)
        paragraphCell.backgroundColor = UIColor.Theme.gray
        return paragraphCell
    }
    
    func get_venue_cell(_ indexPath: IndexPath) -> UITableViewCell {
        let venueCell: VenueCell = self.info_table.dequeueReusableCell(withIdentifier: "venueCell", for: indexPath) as! VenueCell
        venueCell.displayDiscountPreview = false
        venueCell.showHeader = true
        venueCell.set(self.event.venue, user_location: nil)
        venueCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.go_to_venue)))
        return venueCell
    }
}


extension EventController {
    
    @objc func goToAttendance(){
        let userTableController = UserTableController()
        userTableController.event = self.event
        self.navigationController?.pushViewController(userTableController, animated: true)
    }
    
    @objc func inviteFriends() {
        DispatchQueue.main.async {
            let selectableUserController = SelectableUserTableController()
            selectableUserController.event = self.event
            self.navigationController?.pushViewController(selectableUserController, animated: true)
        }
    }
    
    @objc func buyDrinks() {
        let alertController = UIAlertController(title: "Unavailable", message: "In construction", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default)
        alertController.addAction(okAction)
        
        self.present(alertController,animated: true, completion: nil)
    }
    
    @objc func openOptions() {
        let alertController = UIAlertController(title: nil,message: nil, preferredStyle: .actionSheet)
        
        let leaveEventAction = UIAlertAction(title: "Leave Event", style: .default) { (alertAction) in
            self.leaveEvent()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(leaveEventAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController,animated: true, completion: nil)
    }
    
    @objc func claim_discounts() {
        let selectableDiscountTableController = SelectableDiscountTableController()        
        selectableDiscountTableController.event = self.event
        self.navigationController?.pushViewController(selectableDiscountTableController, animated: true)
    }
    
    @objc func join_event() {
        // check if user is available on the chosen date
        let indicator = self.show_and_get_indicator()
        User.is_free(on: self.event!.get_date(), callback: { userIsFree in
            DispatchQueue.main.async {
                self.stop_indicating(indicator: indicator)
                
                if userIsFree {
                    self.event.attend()
                    self.event.isAttending = true
                    self.event.attendance += 1
                    self.info_table.reloadData()
                } else {
                    let alertController = UIAlertController(title: "Cannot Join Event",message: "You already have an event scheduled for \(self.event.date).", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "OK", style: .default)
                    alertController.addAction(action)
                    
                    self.present(alertController,animated: true,completion: nil)
                }
            }
        })
    }
    
    @objc func leaveEvent(){
        let indicator = self.show_and_get_indicator()
        self.event.leave {
            DispatchQueue.main.async {
                self.stop_indicating(indicator: indicator)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    
    @objc func go_to_venue() {
        let venueController = VenueController()
        venueController.set(self.event.venue)
        self.navigationController?.pushViewController(venueController, animated: true)
    }

    
}
