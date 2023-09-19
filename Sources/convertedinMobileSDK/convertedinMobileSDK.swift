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
        
//        self.identifyUser(email: "eslam.ali4233@gmail.com", countryCode: nil, phone: nil)
    }
    
    //MARK:- Functions
   public func identifyUser(email: String?, countryCode: String?, phone: String?){
        guard let pixelId else {return}
        guard let storeUrl else {return}
        let Url = String(format: "https://test.convertedin.com/api/v1/\(pixelId)/identity")
        guard let serviceUrl = URL(string: Url) else { return }
   
        var parameterDictionary = ["csid": "deviceToken" ]
        if let email = email {
            parameterDictionary["email"] = email
        }
        
        if let countryCode = countryCode, let phone = phone {
            parameterDictionary["country_code"] = countryCode
            parameterDictionary["phone"] = phone
        }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue(storeUrl, forHTTPHeaderField: "Referer")
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {return}
            guard let response = response else {return}
            guard  let data = data else {return}
                do {
                    let usermodel: identifyUserModel  = try CustomDecoder.decode(data: data)
                    print(usermodel)
                } catch {
                    print(error)
                }
        }.resume()
    }
    
    public func getuserdata(email: String?, countryCode: String?, phone: String?){
        guard let pixelId else {return}
        guard let storeUrl else {return}
        
        var parameterDictionary = ["csid": "deviceToken" ]
        if let email = email {
            parameterDictionary["email"] = email
        }
        
        if let countryCode = countryCode, let phone = phone {
            parameterDictionary["country_code"] = countryCode
            parameterDictionary["phone"] = phone
        }
        
        NetworkManager.shared.PostAPI(pixelId: pixelId, storeUrl: storeUrl, parameters: parameterDictionary, type: .identify) { data in
            guard  let data = data else {return}
                do {
                    let usermodel: identifyUserModel  = try CustomDecoder.decode(data: data)
                    print(usermodel)
                } catch {
                    print(error)
                }
        }
        
    }
}
