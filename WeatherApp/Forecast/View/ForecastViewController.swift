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
        view.backgroundColor = UIColor.headerViewColor
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
    
    private var forecastViewModels: [ForecastViewModel] = []
    private var groupedForecastViewModels: [[ForecastViewModel]] = []
    
    var forecastViewModel: ForecastViewModel?
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .darkGray
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let weather = [Weather(id: 0, main: "", description: "", icon: "")]
        let main = Main(temp: 0.0, tempMin: 0.0, tempMax: 0.0, pressure: 0, humidity: 0)
        let list = List(main: main, weather: weather, time: "")
        forecastViewModel = ForecastViewModel(list: list)
        
        forecastViewModel?.forecastViewModelDelegate = self
        forecastViewModel?.getForecastFromCache()
        
        configure()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.reuseID)
        
        configureLocationManager()
        
        view.addSubview(activityIndicator)
        configureActivityIndicator()
        activityIndicator.startAnimating()
    }
    
    //MARK: - configure()
    
    private func configure() {
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

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    //MARK: - configureActivityIndicator()      
    private func configureActivityIndicator() {                          
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.hidesWhenStopped = true
    }
    
    //MARK: - configureLocationManager()
    private func configureLocationManager() {
        locationManagerDelegate = LocationManagerDelegate()
        locationManager.delegate = locationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManagerDelegate?.forecastLocationDelegate = forecastViewModel
    }
}

//MARK: - ForecastViewModelDelegate
extension ForecastViewController: ForecastViewModelDelegate {
    
    func useData(_ data: ForecastWeather) {
        
        let lists = data.list
        forecastViewModels = lists.map({return ForecastViewModel(list: $0)})
        groupedForecastViewModels = DaysHandler.groupDays(self.forecastViewModels)
        
        headerLabel.text = "Downloading..."
        headerLabel.font = UIFont.systemFont(ofSize: 17)
        
        tableView.reloadData()
    }
    
    func updateData(_ data: ForecastWeather) {
        let city = data.city.name
        self.headerLabel.text = city
        self.headerLabel.font = UIFont.systemFont(ofSize: 20)
        
        let lists = data.list
        self.forecastViewModels = lists.map({return ForecastViewModel(list: $0)})
        self.groupedForecastViewModels = DaysHandler.groupDays(self.forecastViewModels)
        
        self.tableView.reloadData()
        activityIndicator.stopAnimating()
    }
}

//MARK: - UITableViewDataSource
extension ForecastViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        groupedForecastViewModels.count
    }
    
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        getDate(in: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groupedForecastViewModels[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.reuseID, for: indexPath) as! ForecastTableViewCell
        
        let forecastViewModel = groupedForecastViewModels[indexPath.section][indexPath.row]
        cell.forecastViewModel = forecastViewModel
        
        return cell
    }
    
    func getDate(in section: Int) -> String {
        var date = ""
        
        if let days = groupedForecastViewModels[section].first {
            let time = days.list.time
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
}

extension ForecastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? 50 : 20
    }
}

