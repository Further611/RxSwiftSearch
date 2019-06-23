//
//  Notify.swift
//  ContactList
//
//  Created by Tien Tran on 6/21/19.
//  Copyright © 2019 Tien Tran. All rights reserved.
//

import UIKit

class Notify: NSObject {
    static let shared = Notify()
    
    fileprivate var listener = [NSObject]()
    
    // MARK: - Notification Name
    struct Name {
        struct Contact {
            static let list = Notification.Name.init("contact.list")
            static let detail = Notification.Name.init("contact.detail")
        }
    }
    
    // MARK: - Static Method
    static func post(name: Notification.Name, sender: NSObject? = nil, userInfo: [String: Any]? = nil) {
        NotificationCenter.default.post(name: name, object: (sender == nil ? self : sender), userInfo: userInfo)
    }
    
    
    // MARK: - Public Methods
    func listen(_ sender: NSObject, selector: Selector, name: Notification.Name? = nil, object: Any? = nil) {
        NotificationCenter.default.addObserver(sender, selector: selector, name: name, object: object)
        listener.append(sender)
    }
    
    func removeListener(_ listener: NSObject, name: Notification.Name? = nil, object: Any? = nil) {
        if let index = self.listener.firstIndex(where: {$0 == listener}) {
            self.listener.remove(at: index)
            NotificationCenter.default.removeObserver(listener, name: name, object: object)
        }
    }
    
    func removeAllListener() {
        let nCenter = NotificationCenter.default
        for anObject in listener {
            nCenter.removeObserver(anObject)
        }
        listener.removeAll()
    }
}
