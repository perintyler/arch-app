import Foundation
import UIKit

class DiscountTableController: UIViewController {
    
    var discounts: [Discount]!
    
    var discountTable: UITableView = {
        let table = UITableView()
        table.register(SelectableDiscountCell.self, forCellReuseIdentifier: "discountCell")
        table.backgroundColor = UIColor.Theme.gray
        table.rowHeight = 125.0
        table.separatorStyle = .none
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.Theme.gray
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.discountTable.frame = self.view.frame
        self.discounts.sort(by: { $0.size < $1.size })

        self.view.addSubview(self.discountTable)
        self.discountTable.dataSource = self
    }
    
}


extension DiscountTableController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.discounts.count
        if count == 0 {
            tableView.setEmptyMessage("Event hasn't reached a discount tiers yet")
        } else {
            tableView.restore()
        }
        return self.discounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SelectableDiscountCell = tableView.dequeueReusableCell(withIdentifier: "discountCell", for: indexPath) as! SelectableDiscountCell
        let discount = self.discounts[indexPath.row]
        cell.set(discount, row: indexPath.row)
        
        return cell
    }
    
}
