//
//  LocationManagerDelegate.swift
//  WeatherApp
//
//  Created by Elena Alekseeva on 9/4/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManagerDelegate: UIViewController, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    weak var viewController: UIViewController?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationManager.stopUpdatingLocation()
        guard let location = locations.last else { return } 
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        if let todayViewController = viewController as? TodayViewController {
            todayViewController.getCurrentWeather(latitude: latitude, longitude: longitude)
        }
    }
}
