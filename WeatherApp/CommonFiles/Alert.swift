//
//  Alert.swift
//  WeatherApp
//
//  Created by Elena Alekseeva on 9/6/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import UIKit

struct Alert {
    
    static func locationServiceIsDisabled(_ sender: UIViewController) {
        
        let title = "Location Services are disabled"
        let message = "Please enable Location Services in your Settings"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        sender.present(alert, animated: true, completion: nil)
    }
    
    static func noInternetConnection(_ sender: UIViewController) {
        
        let title = "No internet connection"
        let message = "Please connect to the internet"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        sender.present(alert, animated: true, completion: nil)
    }
}
