// Convertedin Mobile SDK

import Foundation
public struct convertedinMobileSDK {
    
    //MARK:- Variables
    public private(set) var text = "Hello, World!!!!!"
    private var pixelId : String?
    private var storeUrl : String?
    
    //MARK:- Initlizers
    public init(pixelId: String, storeUrl: String) {
        self.pixelId = pixelId
        self.storeUrl = storeUrl
        
        self.identifyUser(email: "e.ali@converted.in", countryCode: nil, phone: nil)
    }
    
    //MARK:- Functions
    //    public func identifyUser(email: String?, countryCode: String, phone: String?){
    //        let url = URL(string: "")
    //        URLSession.shared.dataTask(with: url!) { data, response, error in
    //
    //             guard let data else { return }
    //             guard let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode else { return }
    //
    //             // JSONDecoder() converts data to model of type Array
    ////             do {
    ////                 //let products = try JSONDecoder().decode([Products].self, from: data)
    //////                 completion(.success(products))
    ////             }
    ////             catch {
    ////
    ////             }
    //         }.resume()
    //
    //    }
    
    
    public func identifyUser(email: String?, countryCode: String?, phone: String?){
        
        //declare parameter as a dictionary which contains string as key and value combination.
        guard let pixelId else {return}
        guard let storeUrl else {return}
        var parameters = ["csid": "deviceToken" ]
        if let email = email {
            parameters["email"] = email
        }
        
        if let countryCode = countryCode, let phone = phone {
            parameters["country_code"] = countryCode
            parameters["phone"] = phone
        }
        
        //create the url with NSURL
        let url = URL(string: "https://test.convertedin.com/api/v1/\(pixelId)/identity")!
        
        //create the session object
        let session = URLSession.shared
        //now create the Request object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to data object and set it as request body
        } catch let error {
            print(error.localizedDescription)
            
        }
        
        //HTTP Headers
        request.addValue("Referer", forHTTPHeaderField: storeUrl)
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard error == nil else { return }
            
            guard let data = data else { return }
            

            do {
                let userData = try JSONSerialization.data(withJSONObject: data, options: [])
              //  let userData = try JSONDecoder().decode(identifyUserModel.self, from: data)
                print("==========")
                print(userData)
            }
            catch let error {
                print(error.localizedDescription)
            }
            
            
            
//            do {
//                //create json object from data
//                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
//                print(json)
//
//            } catch let error {
//                print(error.localizedDescription)
//            }
        })
        
        task.resume()
    }
    
}

struct identifyUserModel: Codable {
    let cid: String?
    let  csid: String?
}
