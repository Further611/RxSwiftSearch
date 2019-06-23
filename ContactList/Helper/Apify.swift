//
//  Apify.swift
//  ContactList
//
//  Created by Tien Tran on 6/21/19.
//  Copyright © 2019 Tien Tran. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

public enum RequestCode: Int {
    // MARK: - Request Code List
    case none = 0,
    contactList = 1,
    contactDetail = 2
}

class Apify: NSObject {
    static let shared = Apify()
    fileprivate var prevOperationCodes = [RequestCode]()
    fileprivate var prevOperationData: [String:Any]?
    
    // MARK: - Server URL
    fileprivate let API_URL_BASE = "http://dummy.restapiexample.com"
    
    // MARK: - List & Detail URL
    fileprivate let API_URL_CONTACT_LIST = "/api/v1/employees"
    fileprivate let API_URL_CONTACT_DETAIL = "/api/v1/employee/"
    
    // MARK: - API Functions
    func getContactList () {
        let urlString = API_URL_BASE + API_URL_CONTACT_LIST
        request(urlString, method: .get, parameters: nil, headers: nil, code: .contactList)
    }
    
    func getContactDetail (_ idString : String) {
        let urlString = API_URL_BASE + API_URL_CONTACT_DETAIL + idString
        request(urlString, method: .get, parameters: nil, headers: nil, code: .contactDetail)
    }
    
    // MARK: - Common Functions
    fileprivate func getHeaders(_ withAuthorization: Bool, accept: String? = nil) -> [String: String] {
        var headers = [String: String]()
        
        // Assign accept properties
        if accept == nil { headers["Accept"] = "application/json" }
        else { headers["Accept"] = accept }
        
        return headers
    }
    
    fileprivate func request(_ url: String, method: HTTPMethod, parameters: [String:String]?, headers: [String:String]?, code: RequestCode) {
        
        // Save request data in case if request is failed due to expired token
        var requestData = ["url": url, "method": method] as [String : Any]
        if parameters != nil { requestData["parameters"] = parameters }
        if headers != nil { requestData["headers"] = headers }
        
        // Perform Request
        Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON{ response in
                
                if let index = self.prevOperationCodes.firstIndex(where: { $0 == code }) {
                    self.prevOperationCodes.remove(at: index)
                }
                
                switch response.result {
                    
                case .success:
                    print("[ Success ] Request Code : \(code)")
                    
                    let addData: [String: Any]? = response.data == nil ? nil : ["json": try! JSON(data: response.data!)]
                    self.consolidation(code, success: true, additionalData: addData)
                    
                case .failure:
                    print("[ Failed ] Request Code : \(code)")
                    print("[ ERROR ] : Error when executing API operation : \(code) ! Details :\n" + (response.result.error?.localizedDescription ?? ""))
                    print("[ ERROR ] : URL : " + (response.request?.url?.absoluteString ?? ""))
                    print("[ ERROR ] : Headers : %@", response.request?.allHTTPHeaderFields as Any)
                    print("[ ERROR ] : Result : %@", response.result.value as Any)
                    
                    if let json = JSON.init(rawValue: response.data as Any) {
                        print("[ ERROR ] Error JSON : \(json)")
                        
                        self.consolidation(code, success: false, additionalData: ["json" : json])
                    }else {
                        self.consolidation(code, success: false)
                    }
                    
                }
        }
    }
    
    fileprivate func consolidation(_ requestCode: RequestCode, success: Bool, additionalData: [String: Any]? = nil) {
        // Prepare user info dictionary
        var dict = [String: Any]()
        dict["success"] = success
        
        if additionalData != nil {
            for (key, value) in additionalData! {
                dict[key] = value
            }
        }
        
        switch requestCode {
        case .contactList:
            Notify.post(name: Notify.Name.Contact.list, sender: self, userInfo: dict)
            
        case .contactDetail:
            Notify.post(name: Notify.Name.Contact.detail, sender: self, userInfo: dict)
            
        default:
            break
        }
    }
}
