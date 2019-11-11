import Foundation
import UIKit

class DiscountPreviewCell: UITableViewCell {
    
    
    static let row_height: CGFloat = 50.0
    
    var discounts: [Discount]!
    var discountCollection: UICollectionView!

    func set(_ discounts: [Discount]) {
        self.create_discount_collection(discounts: discounts)
        self.discounts = discounts
        self.discountCollection.dataSource = self
        self.discountCollection.delegate = self
        self.discountCollection.reloadData()
    }
    
    private func create_discount_collection(discounts: [Discount]) {

        // compute collection view frame
        let vertical_margin: CGFloat = 10.0
        let collection_width = 0.9 * self.bounds.width
        let collection_height = self.bounds.height - vertical_margin*2
        let collection_x_min = (self.bounds.width - collection_width) / 2.0
        let collection_frame = CGRect(x: collection_x_min, y: vertical_margin, width: collection_width, height: collection_height)
        
        // get rid of all spacing inbetween cells, so the cells touch at their borders
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize.zero;
        layout.footerReferenceSize = CGSize.zero;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        // create and setup collection
        self.discountCollection = UICollectionView(frame: collection_frame, collectionViewLayout: layout)
        self.discountCollection.register(DiscountCell.self, forCellWithReuseIdentifier: "discountCell")
        self.discountCollection.backgroundColor = UIColor.Theme.gray
        
        // turn off user interaction on collection view to disable scroll
        self.discountCollection.isUserInteractionEnabled = false
    }
    
    
    static func get_height(discountCount: Int) -> CGFloat {
        let margin_height: CGFloat = 16.0
        let table_height: CGFloat = DiscountPreviewCell.row_height * CGFloat(discountCount + 1)
        return margin_height + table_height
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.selectionStyle = .none
        self.backgroundColor = UIColor.Theme.gray
        self.addSubview(self.discountCollection)
    }

    private func should_set_label(for indexPath: IndexPath) -> Bool {
        return indexPath.row == 1 || indexPath.section < 2 || self.discounts[indexPath.section - 2].size != self.discounts[indexPath.section - 1].size
    }
}

extension DiscountPreviewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.discounts.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DiscountCell = collectionView.dequeueReusableCell(withReuseIdentifier: "discountCell", for: indexPath) as! DiscountCell
        if indexPath.section == 0 {
            cell.setup_header_cell(indexPath: indexPath)
        } else if self.should_set_label(for: indexPath) {
            cell.set(discounts: self.discounts, indexPath: indexPath)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.0, height: DiscountPreviewCell.row_height)
    }
    
    
}

