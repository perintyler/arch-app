import Foundation
import UIKit
import CoreLocation

/*
 * Displays all information neccessary for a single venue.
 * Cards included in a venue view:
 *      - Message (description)
 *      - Map (location)
 *      - Group (friends attending)
 *      - 
 */
class VenueController: UIViewController {
    
    var venue: Venue!
    var user_location: CLLocation!
    
    // gets populated with 3 cells: An Event Header Cell, a Paragraph Cell, and a MapCell
    var info_table: UITableView!

    func set(_ venue: Venue) {
        self.venue = venue
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setup_info_collection()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.view.backgroundColor = UIColor.Theme.gray
    }

    private func setup_info_collection() {
        self.info_table = UITableView(frame: self.view.bounds)
        self.info_table.backgroundColor = UIColor.Theme.gray
        self.info_table.separatorStyle = .none
        
        self.info_table.register(VenueHeader.self, forCellReuseIdentifier: "venueHeaderCell")
        self.info_table.register(DiscountPreviewCell.self, forCellReuseIdentifier: "discountTableCell")
        self.info_table.register(DescriptionCell.self, forCellReuseIdentifier: "paragraphCell")
        self.info_table.register(MapCell.self, forCellReuseIdentifier: "mapCell")

        self.info_table.dataSource = self
        self.info_table.delegate = self
        
        
        
        self.view.addSubview(self.info_table)
    }
    
    @objc func show_discounts(){
        let discountCollectionController = DiscountTableController()
        discountCollectionController.discounts = self.venue.discounts
        self.navigationController?.pushViewController(discountCollectionController, animated: true)
    }
    
    @objc func startCreateEventFlow(){
        let inputController = SelectDateController()
        inputController.input_info["venue"] = self.venue.id
        self.navigationController?.pushViewController(inputController, animated: true)
    }

}

extension VenueController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let collection_width = self.info_table.frame.width
        
        let header_height: CGFloat = VenueHeader.height
        let discountTableHeight = DiscountPreviewCell.get_height(discountCount: self.venue.discounts.count)
        let desription_height: CGFloat = DescriptionCell.get_height(text: venue.desc, width: collection_width)
        let map_height: CGFloat = 300.0
        
        switch indexPath.row {
            // header cell: venue picture, name, and main info, and buttons
            case 0: return header_height
            case 1: return discountTableHeight
            // paragraph cell: venue description
            case 2: return desription_height
            // map cell: venue location
            default: return map_height
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            case 0: return self.get_header_cell(for: indexPath)
            case 1: return self.get_discount_preview_cell(for: indexPath)
            case 2: return self.get_description_cell(for: indexPath)
            default: return self.get_map_cell(for: indexPath)
        }
    }
    
    private func get_header_cell(for indexPath: IndexPath) -> UITableViewCell {
        let header_cell: VenueHeader = self.info_table.dequeueReusableCell(withIdentifier: "venueHeaderCell", for: indexPath) as! VenueHeader
        header_cell.set(venue: self.venue)
        //set the actions for the butttons
        header_cell.createEventButton.addTarget(self, action:  #selector(self.startCreateEventFlow), for: .touchUpInside)
        return header_cell
    }
    
    private func get_discount_preview_cell(for indexPath: IndexPath) -> UITableViewCell {
        let discount_preview_cell: DiscountPreviewCell = self.info_table.dequeueReusableCell(withIdentifier: "discountTableCell", for: indexPath) as! DiscountPreviewCell
        discount_preview_cell.set(self.venue.discounts)
        return discount_preview_cell
    }
    
    private func get_description_cell(for indexPath: IndexPath) -> UITableViewCell {
        let description_cell: DescriptionCell = self.info_table.dequeueReusableCell(withIdentifier: "paragraphCell", for: indexPath) as! DescriptionCell
        description_cell.set(self.venue.desc)
        description_cell.backgroundColor = UIColor.Theme.gray
        return description_cell
    }
    
    private func get_map_cell(for indexPath: IndexPath) -> UITableViewCell {
        let map_cell: MapCell = self.info_table.dequeueReusableCell(withIdentifier: "mapCell", for: indexPath) as! MapCell
        
        if let location = self.user_location {
            map_cell.set(venue: self.venue, user_loc: location)
        }
        map_cell.backgroundColor = UIColor.Theme.gray
        return map_cell
    }
    
}

