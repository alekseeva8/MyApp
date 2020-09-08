//
//  LocationManagerDelegate.swift
//  WeatherApp
//
//  Created by Elena Alekseeva on 9/4/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    weak var viewController: UIViewController?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationManager.stopUpdatingLocation()
        guard let location = locations.last else { return } 
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        if let todayViewController = viewController as? TodayViewController {
            todayViewController.getWeather(on: .currentWeather, latitude: latitude, longitude: longitude)
        }
        if let forecastViewController = viewController as? ForecastViewController {
            forecastViewController.getForecast(on: .forecast, latitude: latitude, longitude: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            guard let viewController = viewController else {return}
            Alert.locationServiceIsDisabled(viewController)
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
    }    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location", error)
    }
}
