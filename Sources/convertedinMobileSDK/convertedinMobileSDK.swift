// Convertedin Mobile SDK

import Foundation
public class convertedinMobileSDK {
    
    //MARK:- Variables
    private var pixelId : String?
    private var storeUrl : String?
    private var cid: String?
    private var cuid: String?
   
   public enum eventType: String {
        case purchase = "Purchase"
        case checkout = "InitiateCheckout"
        case addToCart = "AddToCart"
        case viewPage = "PageView"
        case viewContent = "ViewContent"
    }
    
    
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
                    let identifyUserModel: identifyUserModel  = try CustomDecoder.decode(data: data)
                    print(identifyUserModel)
                    self.cid = identifyUserModel.cid
                    self.cuid = identifyUserModel.csid

                } catch {
                    print(error)
                }
        }
    }
    
    public func addCustomEvent(eventName: String, currency: String ,total: String ,products: [String: Any]){
        guard let pixelId else {return}
        guard let storeUrl else {return}
        guard let cid else {return}
        guard let cuid else {return}
        
        // Body [event,cid,cuid,data]
        let parameterDictionary:  [String: Any] = [
            "event" : eventName,
            "cuid": cuid,
            "cid" : cid,
            "data" : [
                "currency" : currency,
                "value": total,
                "content" : products
            ] as [String : Any]
        ]
        
        NetworkManager.shared.PostAPI(pixelId: pixelId, storeUrl: storeUrl, parameters: parameterDictionary, type: .event) { data in
            guard  let data = data else {return}
            do {
                let eventModel: eventModel  = try CustomDecoder.decode(data: data)
                print(eventModel.msg ?? "")
                
            } catch {
                print(error)
            }
        }
    }
    
    public func addEvent(event: eventType, currency: String ,total: String ,products: [String: Any]){
        guard let pixelId else {return}
        guard let storeUrl else {return}
        guard let cid else {return}
        guard let cuid else {return}
        
        // Body [event,cid,cuid,data]
        let parameterDictionary:  [String: Any] = [
            "event" : event.rawValue,
            "cuid": cuid,
            "cid" : cid,
            "data" : [
                "currency" : currency,
                "value": total,
                "content" : products
            ] as [String : Any]
        ]
        
        NetworkManager.shared.PostAPI(pixelId: pixelId, storeUrl: storeUrl, parameters: parameterDictionary, type: .event) { data in
            guard  let data = data else {return}
            do {
                let eventModel: eventModel  = try CustomDecoder.decode(data: data)
                print(eventModel.msg ?? "")
                
            } catch {
                print(error)
            }
        }
    }
    
    public func saveDeviceToken(token: String) {
        guard let pixelId else {return}
        guard let storeUrl else {return}
        guard let cid else {return}
        
        let parameterDictionary:  [String: Any] = [
            "customer_id" : cid,
            "device_token": token,
            "token_type" : "iOS",
        ]
        
        NetworkManager.shared.PostAPI(pixelId: pixelId, storeUrl: storeUrl, parameters: parameterDictionary, type: .saveToken) { data in
            guard  let data = data else {return}
            do {
                let eventModel: saveTokenModel  = try CustomDecoder.decode(data: data)
                print(eventModel.message ?? "")
                UserDefaults.standard.setValue(token, forKey: "current_device_token")
            } catch {
                print(error)
            }
        }
    }
    
    public func deleteDeviceToken() {
        guard let token  = UserDefaults.standard.string(forKey: "current_device_token") else {return}
        guard let pixelId else {return}
        guard let storeUrl else {return}
    
        let parameterDictionary:  [String: Any] = [
            "device_token": token,
            "token_type" : "iOS",
        ]
        
        NetworkManager.shared.PostAPI(pixelId: pixelId, storeUrl: storeUrl, parameters: parameterDictionary, type: .deleteToken) { data in
            guard  let data = data else {return}
            do {
                let eventModel: saveTokenModel  = try CustomDecoder.decode(data: data)
                print(eventModel.message ?? "")
                UserDefaults.standard.setValue(token, forKey: "current_device_token")
            } catch {
                print(error)
            }
        }
    }
    
    public func refreshDeviceToken(newToken: String){
        deleteDeviceToken()
        guard let pixelId else {return}
        guard let storeUrl else {return}
        let oldToken = UserDefaults.standard.string(forKey: "current_device_token") ?? ""
        
        let parameterDictionary:  [String: Any] = [
            
            "device_token": oldToken,
            "token_type" : "iOS",
            "new_device_token": newToken,
            "new_token_type" : "iOS",
        ]
        
        NetworkManager.shared.PostAPI(pixelId: pixelId, storeUrl: storeUrl, parameters: parameterDictionary, type: .refreshToken) { data in
            guard  let data = data else {return}
            do {
                let eventModel: saveTokenModel  = try CustomDecoder.decode(data: data)
                print(eventModel.message ?? "")
                UserDefaults.standard.setValue(newToken, forKey: "current_device_token")
            } catch {
                print(error)
            }
        }
    }
    
}
