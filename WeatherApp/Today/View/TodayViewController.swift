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
    
    var currentViewModel: CurrentViewModel! {
        didSet {
            let data = Converter.convert(currentViewModel)
            locationLabel.text = "\(data.city), \(data.country)"
            WeatherConditionHandler.setImage(for: self.imageView, with: data.weatherID)
            weatherLabel.text = "\(data.temperature)°C | \(data.description)"
            humidityLabel.text = "\(data.humidity)%"
            airPressureLabel.text = "\(data.pressure)hPa"
            windLabel.text = "\(data.windSpeed)\nkm/h"
            minTempLabel.text = "\(data.minTemp)°C"
            maxTempLabel.text = "\(data.maxTemp)°C"
        }
    }
    
    private let backgroundView: UIImageView = {
        let image = UIImage(named: "splash")
        let bgView = UIImageView(image: image)
        bgView.alpha = 0.4
        return bgView
    }()
    
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
        view.backgroundColor = UIColor.headerViewColor
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
    
    private var textToShare: [String] = []
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .darkGray
        return activityIndicator
    }()
    
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let weather = [Weather(id: 0, main: "", description: "", icon: "")]
        let main = Main(temp: 0.0, tempMin: 0.0, tempMax: 0.0, pressure: 0, humidity: 0)
        let wind = Wind(speed: 0.0)
        let sys = Sys(country: "")
        let name = ""
        let currentWeather = CurrentWeather(weather: weather, main: main, wind: wind, sys: sys, name: name)
        currentViewModel = CurrentViewModel(currentWeather: currentWeather)
        
        currentViewModel.currentViewModelDelegate = self
        currentViewModel.getWeatherFromCache()
        
        configureLocationManager()
        
        configure() 
        
        view.addSubview(activityIndicator)
        configureActivityIndicator()
        activityIndicator.startAnimating()
        
        APIHandler.viewController = self
    }
    
    //MARK: - configure()    
    private func configure() {
        
        view.backgroundColor = .white
        view.addSubview(backgroundView)
        
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
        weatherLabel.text = "--°C | --"
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
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
    
    //MARK: - configureActivityIndicator()    
    private func configureActivityIndicator() {                          
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerYAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 30).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.hidesWhenStopped = true
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
        locationManagerDelegate?.currentLocationDelegate = self.currentViewModel
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
            humidityLabel.text = "--%"
        case .airPressure:
            airPressureLabel = label
            airPressureLabel.text = "--hPa"
        case .wind:
            windLabel = label
            windLabel.text = "--\nkm/h"
        case .minTemperature:
            minTempLabel = label
            minTempLabel.text = "--°C"
        case .maxTemperature:
            maxTempLabel = label
            maxTempLabel.text = "--°C"
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

//MARK: - CurrentViewModelDelegate
extension TodayViewController: CurrentViewModelDelegate {
    
    func useData(_ data: CurrentWeather) {
        currentViewModel = CurrentViewModel(currentWeather: data)
        textToShare = composeText(from: currentViewModel)
        headerLabel.text = "Downloading..."
        headerLabel.font = UIFont.systemFont(ofSize: 17)
    }
    
    func updateData(_ data: CurrentWeather) {
        currentViewModel = CurrentViewModel(currentWeather: data)
        textToShare = self.composeText(from: currentViewModel)
        headerLabel.text = "Today"
        headerLabel.font = UIFont.systemFont(ofSize: 20)
        activityIndicator.stopAnimating()
    }
    
    private func composeText(from viewModel: CurrentViewModel) -> [String] {
        
        let data = Converter.convert(viewModel)
        let text = "City: \(data.city), country: \(data.country). \(data.description), \(data.temperature)°C. Humidity: \(data.humidity)%. Air pressure: \(data.pressure)hPa. Wind speed: \(data.windSpeed)\nkm/h"
        return [text]
    }
}
