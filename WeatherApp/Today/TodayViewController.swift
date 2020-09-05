//
//  TodayViewController.swift
//  WeatherApp
//
//  Created by Elena Alekseeva on 9/3/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import UIKit
import CoreLocation

class TodayViewController: UIViewController {
    
    private enum Category: String {
        case humidity = "Humidity" 
        case rainfall = "Rainfall"
        case airPressure = "Temperature"
        case wind = "Wind" 
        case direction = "Direction"
    }
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Today" 
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
    
    private var imageView: UIImageView = {
        let image = UIImage()
        let view = UIImageView(image: image)  
        return view
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private let weatherLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
    private let topStackView = UIStackView().emptyStackView
    private let topStack = UIStackView().emptyStackView
    private let bottomStack = UIStackView().emptyStackView
    
    private let shareButton: UIButton = {
        let buttonFrame = CGRect(x: 0, y: 0, width: 128, height: 42)
        let button = UIButton(frame: buttonFrame)
        button.setTitle("Share", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20) 
        return button
    }()
    
    private let headerViewHeight = 60
    private let topStackViewHeight = 90
    private let topStackHeight = 40
    private let bottomStackHeight = 40
    private let shareButtonHeight = 20
    
    private var locationManagerDelegate: LocationManagerDelegate?
    private var locationManager = CLLocationManager()
    private var currentWeather: CurrentWeather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLocationManager()
        
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
        
        let safeAreaHeight = view.bounds.height - 10 - 90
        let heightsToSubtract = CGFloat(headerViewHeight + topStackViewHeight + topStackHeight + 10 + bottomStackHeight + shareButtonHeight)
        let distance = (safeAreaHeight - heightsToSubtract) / 4
        
        view.addSubview(topStackView)
        topStackView.insertArrangedSubview(imageView, at: 0)
        topStackView.addArrangedSubview(locationLabel)
        topStackView.addArrangedSubview(weatherLabel)
        imageView.image = UIImage(named: "sun")
        locationLabel.text = "London, UK"
        weatherLabel.text = "22°C | Sunny"
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.axis = .vertical
        topStackView.alignment = .center
        topStackView.spacing = 10
        topStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: distance).isActive = true
        topStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(topStack)
        let humidityStack = createSubstackView(category: .humidity)
        let rainfallStack = createSubstackView(category: .rainfall)
        let temperatureStack = createSubstackView(category: .airPressure)
        topStack.insertArrangedSubview(humidityStack, at: 0)
        topStack.addArrangedSubview(rainfallStack)
        topStack.addArrangedSubview(temperatureStack)
        topStack.alignment = .fill
        topStack.spacing = 100
        
        view.addSubview(bottomStack)
        let windStack = createSubstackView(category: .wind)
        let directionStack = createSubstackView(category: .direction)
        bottomStack.insertArrangedSubview(windStack, at: 0)
        bottomStack.addArrangedSubview(directionStack)
        bottomStack.alignment = .fill
        bottomStack.spacing = 100
        
        topStack.translatesAutoresizingMaskIntoConstraints = false
        topStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topStack.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: distance).isActive = true
        
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        bottomStack.centerXAnchor.constraint(equalTo: topStack.centerXAnchor).isActive = true
        bottomStack.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: 30).isActive = true
        
        view.addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    
    //MARK: - configureLocationManager()
    private func configureLocationManager() {
        locationManagerDelegate = LocationManagerDelegate()
        locationManager.delegate = locationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManagerDelegate?.viewController = self
    }
    
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        DataHandler.getData(latitude: latitude, longitude: longitude) { (currentWeather) in
            print(currentWeather.name)
        }
    }
    
    //MARK: - createSubstackView()
    private func createSubstackView(category: Category) -> UIStackView { 
        let subStackView = UIStackView(arrangedSubviews: [])
        subStackView.axis = .vertical
        subStackView.alignment = .center
        subStackView.spacing = 8
        let imageView = createImageView(title: category)
        subStackView.insertArrangedSubview(imageView, at: 0)
        let label = createLabel(title: category)
        subStackView.addArrangedSubview(label)
        return subStackView
    }
    
    private func createLabel(title: Category)  -> UILabel {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        switch title {
        case .humidity:
            label.text = "0%"
        case .rainfall:
            label.text = "0.0"
        case .airPressure:
            label.text = "0hPa"
        case .wind:
            label.text = "20\nkm/h"
        case .direction:
            label.text = "SE\n"
        }
        label.textColor = .black
        return label
    }
    
    private func createImageView(title: Category)  -> UIImageView {
        let image = UIImage(named: title.rawValue) ?? UIImage(named: "sunSmall2")
        let imageView = UIImageView(image: image)
        return imageView
    }
}
