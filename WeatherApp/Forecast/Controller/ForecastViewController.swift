//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Elena Alekseeva on 9/3/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import UIKit
import CoreLocation

class ForecastViewController: UIViewController {
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "" 
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private let headerView: UIImageView = {
        let frame = CGRect(x: 0, y: 0, width: 375, height: 70)
        let view = UIImageView(frame: frame)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    private let headerViewHeight = 60
    
    let tableView: UITableView = {
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        let tableView = UITableView(frame: frame, style: .grouped)
        tableView.rowHeight = 80
        return tableView
    }()
    
    private var locationManagerDelegate: LocationManagerDelegate?
    private var locationManager = CLLocationManager()
    
    private var lists: [List] = []
    private var days: [[List]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: -2).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -2).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 2).isActive = true
        headerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(headerViewHeight)).isActive = true
        
        view.addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -15).isActive = true
        headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //MARK: - tableView
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        tableView.dataSource = self
        
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.reuseID)
        
        configureLocationManager()
    }
    
    //MARK: - configureLocationManager()
    private func configureLocationManager() {
        locationManagerDelegate = LocationManagerDelegate()
        locationManager.delegate = locationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManagerDelegate?.viewController = self
    }
    
    func getForecast(on requestCategory: RequestCategory, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        DataHandler.getInfo(on: requestCategory, latitude: latitude, longitude: longitude) { [weak self] (forecastWeather) in
            
            guard let self = self else {return}
            let city = forecastWeather.city.name
            self.headerLabel.text = city
            
            self.lists = forecastWeather.list
            self.days = DaysHandler.groupDays(forecastWeather.list)
            
            self.tableView.reloadData()
        }
    }
}


//MARK: - UITableViewDataSource
extension ForecastViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        days.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var date = ""
        if let day = days[section].first {
            let time = day.time
            let timeSplitted = time.split(separator: " ")
            date = String(timeSplitted.first ?? "")
            let dateSplitted = date.split(separator: "-")
            let day = dateSplitted[2]
            let month = dateSplitted[1]
            let year = dateSplitted[0]
            date = "\(day).\(month).\(year)"
        }
        return date
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        days[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.reuseID, for: indexPath) as! ForecastTableViewCell
        
        let list = days[indexPath.section][indexPath.row]
        cell.list = list
    
        return cell
    }
}

