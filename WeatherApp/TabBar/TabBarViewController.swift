//
//  TabBarViewController.swift
//  WeatherApp
//
//  Created by Elena Alekseeva on 9/13/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let todayVC = TodayViewController()
        todayVC.tabBarItem.title = "Today"
        todayVC.tabBarItem.image = UIImage(systemName: "sun.max")
        
        let forecastVC = ForecastViewController()
        forecastVC.tabBarItem.title = "Forecast"
        forecastVC.tabBarItem.image = UIImage(systemName: "cloud.sun")
        
        let searchVC = SearchViewController()
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 2)
        
        viewControllers = [todayVC, forecastVC, searchVC]
    }
}
