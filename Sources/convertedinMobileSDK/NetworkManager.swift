//
//  NetworkManager.swift
//  
//
//  Created by Eslam Ali  on 19/09/2023.
//

import Foundation


class NetworkManager {
    
    static let shared  = NetworkManager()
    
    enum requestType: String {
        case identify = "identity"
        case event = "event"
    }
    
    func PostAPI(pixelId: String?, storeUrl: String?, parameters: [String: Any], type: requestType, compeletion: @escaping (Data?) -> Void){
        guard let pixelId else {return}
        guard let storeUrl else {return}
        let Url = String(format: "https://test.convertedin.com/api/v1/\(pixelId)/\(type.rawValue)")
        guard let serviceUrl = URL(string: Url) else { return }
   
//        var parameterDictionary = ["csid": "deviceToken" ]
//        if let email = email {
//            parameterDictionary["email"] = email
//        }
//
//        if let countryCode = countryCode, let phone = phone {
//            parameterDictionary["country_code"] = countryCode
//            parameterDictionary["phone"] = phone
//        }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue(storeUrl, forHTTPHeaderField: "Referer")
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {return}
            guard let response = response else {return}
            guard  let data = data else {return}
            compeletion(data)
                do {
                    let usermodel: identifyUserModel  = try CustomDecoder.decode(data: data)
                    print(usermodel)
                } catch {
                    print(error)
                }
        }.resume()
    }
    
}
