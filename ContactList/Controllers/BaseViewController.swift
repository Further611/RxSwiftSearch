//
//  BaseViewController.swift
//  ContactList
//
//  Created by Tien Tran on 6/21/19.
//  Copyright © 2019 Tien Tran. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = kYellowColor.hexColor()
        navigationBarAppearace.barTintColor = kYellowColor.hexColor()
        
        
        
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        // View Controller Settings
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.tintColor = kYellowColor.hexColor()
        if navigationController.navigationBar.isHidden == true {
            navigationController.setNavigationBarHidden(false, animated: true)
        }
    }
}
