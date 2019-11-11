//
//import Foundation
//import UIKit
//import SkyFloatingLabelTextField
//
//class TimeInputController: UIViewController {
//    
//    var inputType: String!
//    var name: String!
//    var desc: String?
//    var img: UIImage?
//    var date: Date!
//    var venueID: String?
//    
//    let message: UILabel = {
//        let label = UILabel()
//        label.text = "Choose a time"
//        label.font = UIFont.Theme.mediumTitleLabel
//        label.textAlignment = .center
//        label.textColor = UIColor.black
//        return label
//    }()
//    
//    let timePicker: UIDatePicker = {
//        let picker = UIDatePicker()
//        picker.datePickerMode = .time
//        return picker
//    }()
//    
//    let button: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = UIColor.Theme.green
//        button.setTitle("Next", for: .normal)
//        button.titleLabel!.textColor = UIColor.black
//        return button
//    }()
//    
//    override func viewDidLoad(){
//        super.viewDidLoad()
//        self.hidesBottomBarWhenPushed = true
//
//        self.view.backgroundColor = UIColor.white
//        self.button.addTarget(self, action: #selector(self.nextPage), for: .touchUpInside)
//        
//        self.view.addSubviews(self.message, self.timePicker, self.button)
//
//        self.view.centerHorizontally(child: self.message)
//        self.view.addConstraintsWithFormat(format: "V:[v0]-50-[v1(250)]", views: self.message, self.timePicker)
//        self.view.centerVertically(child: self.timePicker)
//        self.view.addConstraintsWithFormat(format: "V:[v0(50)]|", views: self.button)
//        self.view.addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: self.timePicker)
//        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: self.button)
//    }
//    
//    @objc func nextPage(){
//        let invitationController = InvitationController()
//        invitationController.navigationItem.title = "Invite Friends"
////        invitationController.time = self.timePicker.date
////        invitationController.inputType = self.inputType
////        invitationController.date = self.date
////        invitationController.desc = self.desc
////        invitationController.name = self.name
////        invitationController.img = self.img
////        invitationController.venueID = venueID
//        self.navigationController?.pushViewController(invitationController, animated: true)
//    }
//}
