//
//  SearchBarDelegate.swift
//  WeatherApp
//
//  Created by Elena Alekseeva on 9/12/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import UIKit

protocol SearchDelegate: class {
    func getWeather(on requestCategory: RequestCategory, city: String)
}


class SearchBarDelegate: NSObject, UISearchBarDelegate {
    
    var searchDelegate: SearchDelegate?
    private var timer: Timer?
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] (_) in
            self?.searchDelegate?.getWeather(on: .currentWeather, city: searchText)
        })
    }
}
