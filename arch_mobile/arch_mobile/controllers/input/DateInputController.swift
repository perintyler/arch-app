import Foundation
import UIKit
import FSCalendar

// change to select date controller
class SelectDateController: UIViewController {
    
    var input_info = [String: Any]()
    
    let button: UIButton = {
        let selectDateButton = UIButton()
        selectDateButton.setTitle("Select Date", for: .normal)
        selectDateButton.backgroundColor = UIColor.Theme.green
        selectDateButton.titleLabel?.textColor = UIColor.white
        selectDateButton.addTarget(self, action: #selector(SelectDateController.selectDate), for: .touchUpInside)
        return selectDateButton
    }()
    
    let calendar: FSCalendar = {
        let calendarView = FSCalendar()
        calendarView.allowsSelection = true
        calendarView.backgroundColor = UIColor.white
        return calendarView
    }()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.navigationItem.title = "Date"
        self.view.backgroundColor = UIColor.white
        
        self.calendar.delegate = self
        self.calendar.dataSource = self
        
        self.view.addSubviews(self.button, self.calendar)

        self.setupConstraints()
    }
    
    
    private func navigate_to_event(_ event: Event) {
        //create event controller to set the created event
        let eventController = EventController()

        eventController.set(event)
        
        //first pop to root controller in navigation stack (no animation)
        let rootController = self.navigationController?.popViewController(animated: false)
        
        //finally navigate from the root controller to event controller, allowing the user to go back
        rootController?.navigationController?.pushViewController(eventController, animated: false)
    }
    
    private func create_event_from_input() {
        
        // get image if it exists and remove it from the input info that gets sent to rest api
        let event_image: UIImage?  = self.input_info.removeValue(forKey: "image") as? UIImage
        
        // set a value to let the back-end know if the event has a custom image
        self.input_info["has_image"] = event_image != nil

        // create the event with the input fields
        Event.create(fields: self.input_info) { event in
            
            // upload the image to firebase storage which can be retrieved later with an event id
            upload_image(event_image!, path: "event", file_name: "\(event.id)")
            
            // navigate to the created event page
            self.navigate_to_event(event)
        }
    }
    
    private func setupConstraints() {
        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: self.calendar)
        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: self.button)
        self.view.addConstraintsWithFormat(format: "V:|[v0][v1(50)]|", views: self.calendar, self.button)
    }
    
}

extension SelectDateController : FSCalendarDataSource, FSCalendarDelegate {
    
    @objc func selectDate() {
        
        if let selected_date = self.calendar.selectedDate {
            
            self.input_info["date"] = selected_date.parse_for_db()
            self.create_event_from_input()
            
        } else{
            let alertController = UIAlertController(title: "Select a date",message: "Please select a date on the calendar", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(action)
            
            self.present(alertController,animated: true,completion: nil)
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let buttonTitle = "Select " + (self.calendar.selectedDate?.formatted())!
        
        DispatchQueue.main.async {
            self.button.setTitle(buttonTitle, for: .normal)
        }
        
    }
    
}
