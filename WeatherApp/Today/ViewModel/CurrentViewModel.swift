//
//  CurrentViewModel.swift
//  WeatherApp
//
//  Created by Elena Alekseeva on 9/7/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import Foundation
import CoreLocation

protocol CurrentViewModelDelegate: class {
    
    func useData(_ data: CurrentWeather)
    func updateData(_ data: CurrentWeather)
}

class CurrentViewModel {
    
    var currentViewModelDelegate: CurrentViewModelDelegate?
    var currentWeather: CurrentWeather
    private var dataHasReceived = false
    
    init(currentWeather: CurrentWeather) {
        self.currentWeather = currentWeather
    }
    
    func getWeatherFromCache() {
        DataHandler.getWeatherFromCache { [weak self] (currentWeather) in
            guard let self = self else {return}
            self.currentViewModelDelegate?.useData(currentWeather)
        }
    }
}

extension CurrentViewModel: CurrentLocationDelegate {
    
    func getWeather(on requestCategory: RequestCategory, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        switch dataHasReceived {
        case false:
            DataHandler.getData(on: requestCategory, latitude: latitude, longitude: longitude) { [weak self] (currentWeather, error) in
                
                switch error {
                case nil:
                    self?.dataHasReceived = true
                    guard let currentWeather = currentWeather else {return}
                    self?.currentViewModelDelegate?.updateData(currentWeather)
                    
                default:
                    print(String(describing: error?.localizedDescription))
                }
            }
        default:
            break
        }
    }
}

