//
//  LocationManagerDelegate.swift
//  WeatherApp
//
//  Created by Elena Alekseeva on 9/4/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationDelegate: class {
    func getWeather(on requestCategory: RequestCategory, latitude: CLLocationDegrees, longitude: CLLocationDegrees)
}

protocol LocationDelegate2: class {
    func getForecast(on requestCategory: RequestCategory, latitude: CLLocationDegrees, longitude: CLLocationDegrees)
}

class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    weak var viewController: UIViewController?
    weak var delegate: LocationDelegate?
    weak var delegate2: LocationDelegate2?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationManager.stopUpdatingLocation()
        guard let location = locations.last else { return } 
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        delegate?.getWeather(on: .currentWeather, latitude: latitude, longitude: longitude)
        delegate2?.getForecast(on: .forecast, latitude: latitude, longitude: longitude)
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
