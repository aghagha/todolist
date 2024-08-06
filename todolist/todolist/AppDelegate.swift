//
//  AppDelegate.swift
//  todolist
//
//  Created by Agha Maulana on 06/08/24.
//

import UIKit

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard window == nil else {
            return true
        }
        
        let mainScreen = TodoListVC()
        let navController = UINavigationController(rootViewController: mainScreen)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        
        return true
    }

}

