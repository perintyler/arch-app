import Foundation
import Firebase
/*
 * This class is used to make rest calls to the api.
 * REST calls currently included:
 *  - GET
 *  - POST
 */
class rest {
    
    static var status = "staging"
    
    static func get(path: String, callback: @escaping (Data, HTTPURLResponse)->()) {
        
        rest.get_jwt_token() { token in

            let url = self.get_api_url(path: path)
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                
                callback(data, response as! HTTPURLResponse)
            }
            task.resume()
        }
    }
    
    
    static func post(path: String, params: [String:Any], callback: @escaping (Data, HTTPURLResponse)->()) {
        
        rest.get_jwt_token() { token in
            
            let url = self.get_api_url(path: path)
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error.debugDescription)
                    return
                }
                
                callback(data, response as! HTTPURLResponse)
                
            }
            task.resume()
        }

    }

    static func get(path: String) {
        rest.get(path: path, callback: { _,_ in })
    }
    
    static func post(path: String, params: [String: Any]) {
        rest.post(path: path, params: params, callback: { _,_ in })
    }
    
    private static func get_jwt_token(callback: @escaping (String)->()) {
        if let currentUser = Auth.auth().currentUser {
            currentUser.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                callback(idToken!)
            }
        } else {
            print("tried to get jwt token but firebase user not logged in")
        }
    }
    
    static func get_api_url(path: String) -> URL {
        if (self.status == "development") {
            return URL(string: "http://127.0.0.1:8000/api/\(path)")!
        } else if (self.status == "staging") {
            return URL(string: "https://arch-api-staging.herokuapp.com/api/\(path)")!
        } else { //production
            return URL(string: "https://arch-api-production.herokuapp.com/api/\(path)")!
        }
    }

}
