//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Elena Alekseeva on 9/3/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.rootViewController = TabBarViewController()
        window?.makeKeyAndVisible()
        return true
    }
}

