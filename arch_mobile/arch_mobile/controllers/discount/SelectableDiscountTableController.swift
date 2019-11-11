import Foundation
import UIKit
import CoreLocation

class SelectableDiscountTableController: UIViewController {
    
    var discounts: [Discount]!
    var event: Event!
    
    var location_manager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    let discountTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(SelectableDiscountCell.self, forCellReuseIdentifier: "selectableDiscountCell")
        table.backgroundColor = UIColor.Theme.gray
        table.tableFooterView = UIView()
        table.rowHeight = 64.0
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add discounts table as subview
        self.view.addSubview(self.discountTable)
        
        // add contraints to fit the discount table to superview
        self.view.fit(subview: self.discountTable)
        
        // get discounts to fill up the discount table
        self.populate_table()
    }
    
    /*
     * Fetch claimable discounts from server and sets the datasource of the discount table
     * which populates the table using the discounts
     */
    private func populate_table() {
        
        let indicator = self.show_and_get_indicator()
        
        self.event.get_discounts { claimable_discounts in
            self.discounts = claimable_discounts
            
            DispatchQueue.main.async {
                self.stop_indicating(indicator: indicator)
                
                self.discountTable.dataSource = self
                self.discountTable.reloadData()
            }
        }
    }
    
    
    
    private func check_user_location(validLocationCallback: @escaping ()->()) {
        var user_location: CLLocation? = self.location_manager.location
        if user_location == nil {
            user_location = (UIApplication.shared.delegate as! AppDelegate).user_location
        }
        if self.event.get_date() > Date() {
            self.alert_event_not_ongoing()
        } else if let user_loc = user_location {
            self.event.venue.get_location { venue_loc in
                let distance = venue_loc.distance(from: user_loc)
                if distance < 1000.0 {
                    validLocationCallback()
                } else {
                    self.alert_invalid_location()
                }
            }
        } else {
            // TEMPORARY
            // TODO we need some way to deal with cases where location is not enabled
            validLocationCallback()
        }
        
    }
    
    private func alert_invalid_location() {
        let alert = UIAlertController(title: "Invalid Location", message: "You must be at the venue to claim a discount", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func alert_event_not_ongoing() {
        let alert = UIAlertController(title: nil, message: "The event hasn't started yet", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func prompt_user(toClaim discount: Discount, createController: @escaping (Discount)->(ClaimDiscountController)) {
        
        self.check_user_location { () in
            let alert = UIAlertController(title: "Claim Discount", message: "Your discount will expire after 30 seconds. Are you ready to claim your discount at the bar?", preferredStyle: .alert)
            
           
            // if users responds 'yes', push a claim discount controller to nav stack
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                let controller = createController(discount)
                self.navigationController?.pushViewController(controller, animated: true)
            }))
            
            // add cancel action
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
        
    }
    
    @objc func claim_discount_pressed(sender: UIButton) {
        // get the picked discount using the set tag of the sender
        let discount = self.discounts[sender.tag]
        self.prompt_user(toClaim: discount, createController: self.get_claim_controller)
    }
    
    func get_claim_controller(for discount: Discount) -> ClaimDiscountController {
        let claimDiscountContoller = ClaimDiscountController()
        claimDiscountContoller.discount = discount
        claimDiscountContoller.event = self.event
        return claimDiscountContoller
    }
}


extension SelectableDiscountTableController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let discountCount = self.discounts.count
        if discountCount == 0 {
            tableView.setEmptyMessage("Your group hasn't reached any discount tiers yet. Invite friends to your event to get discounts.")
        } else {
            tableView.restore()
        }
        return discountCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SelectableDiscountCell = tableView.dequeueReusableCell(withIdentifier: "selectableDiscountCell", for: indexPath) as! SelectableDiscountCell
        let discount = self.discounts[indexPath.row]
        cell.set(discount, row: indexPath.row)
        cell.setClaimAction(selector: #selector(self.claim_discount_pressed(sender:)), target: self)
        return cell
    }
    
}


extension SelectableDiscountTableController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // save the user location in shared app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.user_location = locations.last
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Location error in venue table controller")
    }
    
}
