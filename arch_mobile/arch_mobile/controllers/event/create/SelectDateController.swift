import Foundation
import UIKit
import FSCalendar

class SelectDateController: UIViewController {
    
    var input_info = [String: Any]()
    
    let button: UIButton = {
        let selectDateButton = UIButton()
        selectDateButton.translatesAutoresizingMaskIntoConstraints = false
        selectDateButton.setTitle("Select Date", for: .normal)
        selectDateButton.backgroundColor = UIColor.Theme.green
        selectDateButton.titleLabel?.textColor = UIColor.white
        return selectDateButton
    }()
    
    let calendar: FSCalendar = {
        let calendarView = FSCalendar()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
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
        
        self.button.addTarget(self, action: #selector(SelectDateController.selectDate), for: .touchUpInside)

        
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.addSubviews(self.button, self.calendar)

        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: self.calendar)
        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: self.button)
        self.view.addConstraintsWithFormat(format: "V:|[v0][v1(65)]|", views: self.calendar, self.button)
    }
    
    func go_to_create_event() {
        let createEventController = CreateEventController()
        createEventController.input_info = self.input_info
        self.navigationController?.pushViewController(createEventController, animated: true)
    }
    
}

extension SelectDateController : FSCalendarDataSource, FSCalendarDelegate {
    
    @objc func selectDate() {
        
        // check if the user has selected a date
        if let selected_date = self.calendar.selectedDate {
            
            self.button.isEnabled = false
            self.navigationController?.navigationBar.isUserInteractionEnabled = false

            
            User.is_free(on: selected_date, callback: { userIsFree in
                
                DispatchQueue.main.async {

                    if userIsFree == false {
                        self.alert_invalid_selection(message: "You already have an event scheduled on \(selected_date.parse_as_string())")
                    } else if  selected_date < Date() && selected_date.isToday() == false {
                        self.alert_invalid_selection(message: "Please select a day that hasn't occurred yet.")
                        
                    } else {
                        self.input_info["date"] = selected_date.parse_for_db()
                        self.go_to_create_event()
                    }
                    
                    self.button.isEnabled = true
                    self.navigationController?.navigationBar.isUserInteractionEnabled = true

                }

            })
        } else {
            // no date has been selected yet. alert user to select a date
            self.alert_invalid_selection(message: "Please select a date on the calandar")
        }
    }
    
    private func alert_invalid_selection(message: String) {
        let alertController = UIAlertController(title: "Invalid Date",message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        
        self.present(alertController,animated: true,completion: nil)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let buttonTitle = "Select " + (self.calendar.selectedDate?.formatted())!
        
        DispatchQueue.main.async {
            self.button.setTitle(buttonTitle, for: .normal)
        }
        
    }
    
}

