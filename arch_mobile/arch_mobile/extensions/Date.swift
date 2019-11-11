import Foundation

extension Date {
    
    
    func formatted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: self)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "MMM dd, yyyy"
        
        return formatter.string(from: yourDate!)
        
    }
    
    func formattedTime() -> String {
        return Date.formatTime(str: self.getTime())
        
    }
    
    static func formatTime(str : String) -> String {
        let time = Array(str)
        
        let minute : String = (time[2] == "0" ? String(time[3]) : ( String(time[2]) + String(time[3]) ))
        
        if(time[0] == "0"){
            let hour = String(time[1])
            return hour + ":" + minute + " am"
        }else{
            let hour = String(Int(String(time[0]) + String(time[1]))! - 12)
            return hour + ":" + minute + " pm"
        }
    }
    
    func with_time(time: Date) -> Date {
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: self)
        let hour = components.hour
        let minute = components.minute
        
        let timeInSeconds: Int = hour!*360 + minute!*60
        let newDate = self.addingTimeInterval(TimeInterval(timeInSeconds))
        return newDate
    }
    
    func parse_for_db() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-ddTHH:mm:ssZ"
        return dateFormatter.string(from: self)
    }
    
    func parse_as_string() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.setLocalizedDateFormatFromTemplate("EEE MMM d yyyy")
        return dateFormatter.string(from: self)
    }
    
    func getTime() -> String{
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: self)
        let hour : String = String(components.hour!)
        let minute : String = String(components.minute!)
        
        return (hour.count == 2 ? hour : ("0" + hour)) + (minute.count == 2 ? minute : ("0" + minute))
    }
    
    func isSameDay(as date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    
}

