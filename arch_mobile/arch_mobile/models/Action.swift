import Foundation

struct Action: Decodable {
    
    var user: User
    var venueName: String
    var eventDate: String
    
    static func get_all(callback: @escaping ([Action])->()) {
        rest.get(path: "action/") { (data, response) in
            let decoder = JSONDecoder()
            print(data)
            print(response)
            let actions = try! decoder.decode([Action].self, from: data)
            callback(actions)
        }
    }
    
    func get_message() -> String {
        // parse python datetime string to swift Date object
        let date_from_string = self.eventDate.parseAsDate()
        // format the date object into a readable string
        let formatted_date = date_from_string.formatted()
        
        return " is going to \(self.venueName) on \(formatted_date)"
        
        
        //return "\(self.user.name) is going to \(self.venueName) on \(formatted_date)"
    }
    
}


