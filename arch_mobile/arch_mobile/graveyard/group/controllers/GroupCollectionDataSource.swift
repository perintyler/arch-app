////
////  GroupCollectionDataSource.swift
////  arch_mobile
////
////  Created by Tyler Perin on 8/11/18.
////  Copyright © 2018 arch. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class GroupCollectionDataSource: NSObject {
//    var selectable: [Selection<GroupPreview>]!
//    var selectionEnabled: Bool
//    var isDark: Bool = false
//    
//    init(groups: [GroupPreview], collection: UICollectionView, selectionEnabled: Bool = false){
//        self.selectionEnabled = selectionEnabled
//        
//        DispatchQueue.main.async {
//            collection.register(GroupCell.self, forCellWithReuseIdentifier: "groupCell")
//        }
//
//        self.selectable = groups.map { (group) -> Selection<GroupPreview> in
//            return Selection(value: group)
//        }
//        DispatchQueue.main.async {
//            collection.reloadData()
//        }
//    }
//    
//    func getSelected() -> [GroupPreview] {
//        var selected: [GroupPreview] = []
//        for group in selectable {
//            if(group.selected) {
//                selected.append(group.value)
//            }
//        }
//        return selected
//    }
//    
//    func getGroupForIndexPath(index: IndexPath) -> GroupPreview{
//        return self.selectable[index.row].value
//    }
//    
//    func reload() {
//        db.group.get_all_for_user(id: "\(Authentication.user.id)") { (groups) in
//            self.selectable = groups.map { (group) -> Selection<GroupPreview> in
//                return Selection(value: group)
//            }
//        }
//    }
//    
//    func loadCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell : GroupCell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupCell",
//                                                                  for: indexPath) as! GroupCell
//        cell.set(group: self.selectable[indexPath.row].value)
//        if(self.isDark == true) {
//            cell.turnDark()
//        }
//
//        return cell
//    }
//    
//}
//extension GroupCollectionDataSource: UICollectionViewDataSource, UICollectionViewDelegate {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let amount_of_groups = self.selectable.count
//        if(amount_of_groups == 0){
//            collectionView.setEmptyMessage("You don't have any groups")
//        }else{
//            collectionView.restore()
//        }
//        return amount_of_groups
//    }
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        return self.loadCell(collectionView, cellForItemAt: indexPath)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if(self.selectionEnabled == true) {
//            let groupCell: GroupCell = collectionView.cellForItem(at: indexPath) as! GroupCell
//            let selection = self.selectable[indexPath.row]
//            if(selection.selected) {
//                groupCell.unselect()
//                selection.selected = false
//            } else {
//                groupCell.select()
//                selection.selected = true
//            }
//        }
//            
//    }
//    
//
//}
