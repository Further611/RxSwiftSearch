//
//  DataModel.swift
//  ContactList
//
//  Created by Tien Tran on 6/21/19.
//  Copyright © 2019 Tien Tran. All rights reserved.
//

import UIKit
import SwiftyJSON

class Contact: NSObject {
    var id = ""
    var name = ""
    var salary = ""
    var age = ""
    var imageUrl = ""
    
    override init() {
        super.init()
    }
    
    convenience init(_ data: JSON) {
        self.init()
        
        id = data["id"].string ?? "0"
        name = data["employee_name"].string ?? ""
        salary = data["employee_salary"].string ?? ""
        age = data["employee_age"].string ?? ""
        imageUrl = data["profile_image"].string ?? ""
        
        imageUrl = imageUrl.replacingOccurrences(of: " ", with: "%20")
    }
}
