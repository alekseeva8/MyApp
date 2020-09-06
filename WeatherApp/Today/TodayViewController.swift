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
        case airPressure = "Pressure"
        case wind = "Wind" 
        case minTemperature = "MinTemp"
        case maxTemperature = "MaxTemp"
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
    
    private var humidityLabel = UILabel()
    private var airPressureLabel = UILabel()
    private var windLabel = UILabel()
    private var minTempLabel = UILabel()
    private var maxTempLabel = UILabel()
    
    private let shareButton: UIButton = {
        let buttonFrame = CGRect(x: 0, y: 0, width: 128, height: 42)
        let button = UIButton(frame: buttonFrame)
        button.setTitle("Share", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20) 
        return button
    }()
    
    private let headerViewHeight = 60
    private let topStackViewHeight = 160
    private let topStackHeight = 40
    private let bottomStackHeight = 40
    private let shareButtonHeight = 20
    
    private var locationManagerDelegate: LocationManagerDelegate?
    private var locationManager = CLLocationManager()
    private var currentWeather: CurrentWeather?
    
    private var textToShare: [String] = []
    
    //MARK: - viewDidLoad
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
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
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
        let windStack = createSubstackView(category: .wind)
        let pressureStack = createSubstackView(category: .airPressure)
        topStack.insertArrangedSubview(humidityStack, at: 0)
        topStack.addArrangedSubview(windStack)
        topStack.addArrangedSubview(pressureStack)
        topStack.alignment = .fill
        topStack.spacing = 100
        
        view.addSubview(bottomStack)
        let minTempStack = createSubstackView(category: .minTemperature)
        let maxTempStack = createSubstackView(category: .maxTemperature)
        bottomStack.insertArrangedSubview(minTempStack, at: 0)
        bottomStack.addArrangedSubview(maxTempStack)
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
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
    }
    
    
    //MARK: - shareButtonTapped()
    @objc func shareButtonTapped() {
        let activityVC = ActivityVC(presentor: self)
        activityVC.share(text: textToShare)
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

    
    //MARK: - getWeather()    
    func getWeather(on requestCategory: RequestCategory, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        DataHandler.getData(on: requestCategory, latitude: latitude, longitude: longitude) { [weak self] (currentWeather) in
            guard let self = self else {return}
            let city = currentWeather.name
            let country = currentWeather.sys.country
            self.locationLabel.text = "\(city), \(country)"
            
            var weatherDescription = ""
            var weatherID = 0
            let weatherArray = currentWeather.weather
            weatherArray.forEach { (weather) in
                weatherDescription = weather.main
                weatherID = weather.id
            }
            WeatherConditionHandler.setImage(for: self.imageView, with: weatherID)
            
            let temperature = Int(currentWeather.main.temp)
            self.weatherLabel.text = "\(temperature)°C | \(weatherDescription)"
            
            let humidity = currentWeather.main.humidity
            self.humidityLabel.text = "\(humidity)%"
            let pressure = currentWeather.main.pressure
            self.airPressureLabel.text = "\(pressure)hPa"
            let windSpeed = currentWeather.wind.speed
            self.windLabel.text = "\(windSpeed)\nm/sec"
            
            let minTemperature = Int(currentWeather.main.tempMin)
            self.minTempLabel.text = "\(minTemperature)°C"
            let maxTemperature = Int(currentWeather.main.tempMax)
            self.maxTempLabel.text = "\(maxTemperature)°C"
            
            let text = "City: \(city), country: \(country). \(weatherDescription), \(temperature)°C. Humidity: \(humidity)%. Air pressure: \(pressure)hPa. Wind speed: \(windSpeed)\nm/sec"
            self.textToShare = [text]
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
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 15)
        switch title {
        case .humidity:
            humidityLabel = label
            humidityLabel.text = "0%"
        case .airPressure:
            airPressureLabel = label
            airPressureLabel.text = "0hPa"
        case .wind:
            windLabel = label
            windLabel.text = "0\nm/sec"
        case .minTemperature:
            minTempLabel = label
            minTempLabel.text = "0°C"
        case .maxTemperature:
            maxTempLabel = label
            maxTempLabel.text = "°0C"
        }
        label.textColor = .black
        return label
    }
    
    private func createImageView(title: Category)  -> UIImageView {
        let image = UIImage(named: title.rawValue) ?? UIImage()
        let imageView = UIImageView(image: image)
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return imageView
    }
}
