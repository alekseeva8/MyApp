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
    
    let locationManager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationManager.stopUpdatingLocation()
        guard let location = locations.last else { return } 
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        APIHandler.request(latitude: latitude, longitude: longitude) { (data, error) in
        }
    }
    
}
