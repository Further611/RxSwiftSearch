//
//  AppDelegate.swift
//  contactlist
//
//  Created by Tien Tran on 6/19/19.
//  Copyright © 2019 Tien Tran. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:kYellowColor.hexColor()]
        
        makeRootViewControllerFrom(&window)
        return true
    }
    
    private func makeRootViewControllerFrom(_ currentWindows: inout UIWindow?) {
        currentWindows = UIWindow(frame:UIScreen.main.bounds)
        let contactListController = ContactListViewController(nibName: "ContactListViewController", bundle: nil)
        let currentNavigation = UINavigationController(rootViewController: contactListController)
        currentWindows?.rootViewController = currentNavigation
        currentWindows?.makeKeyAndVisible()
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

