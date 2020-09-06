//
//  ActivityVC.swift
//  WeatherApp
//
//  Created by Elena Alekseeva on 9/6/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import UIKit

struct ActivityVC {
    
    var presentor: UIViewController
    
    func share(text: [String]) {
        let activityVC = UIActivityViewController(activityItems: text, applicationActivities: nil)
        presentor.present(activityVC, animated: true, completion: nil)
    }
}
