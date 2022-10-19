//
//  AppDelegate.swift
//  iOS Test Task 2022
//
//  Created by Владислав Воробьев on 11.10.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navController = UINavigationController()
        let rootVC = MainVC(nibName: nil, bundle: nil)
        navController.viewControllers = [rootVC]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        window?.rootViewController = navController
        
        return true
    }
    
}

