//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Elena Alekseeva on 9/12/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
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
    
    private enum Category: String {
        case humidity = "Humidity" 
        case airPressure = "Pressure"
        case wind = "Wind" 
        case minTemperature = "MinTemp"
        case maxTemperature = "MaxTemp"
    }
    
    private let backgroundView: UIImageView = {
        let image = UIImage(named: "splash")
        let bgView = UIImageView(image: image)
        bgView.alpha = 0.3
        return bgView
    }()
    
    private let headerView: UIImageView = {
        let frame = CGRect(x: 0, y: 0, width: 375, height: 70)
        let view = UIImageView(frame: frame)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = UIColor.headerViewColor
        return view
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter city name"
        return searchBar
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
    
    private let headerViewHeight = 60
    private let topStackViewHeight = 160
    private let topStackHeight = 40
    private let bottomStackHeight = 40
    
    private var searchBarDelegate: SearchBarDelegate?
    
    
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
        
        configure() 
        configureSearchBar()
        
        searchBarDelegate = SearchBarDelegate()
        searchBar.delegate = searchBarDelegate
        searchBarDelegate?.searchDelegate = self.currentViewModel
    }
    
    private func configureSearchBar() {
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 2).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -2).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0).isActive = true
    }
    
    //MARK: - configure()    
    private func configure() {
        
        view.addSubview(backgroundView)
        
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: -2).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -2).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 2).isActive = true
        headerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(headerViewHeight)).isActive = true
        
        let safeAreaHeight = view.bounds.height - 10 - 90
        let heightsToSubtract = CGFloat(headerViewHeight + topStackViewHeight + topStackHeight + 10 + bottomStackHeight + 20)
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

extension SearchViewController: CurrentViewModelDelegate {
    func useData(_ data: CurrentWeather) {
        return
    }
    
    func updateData(_ data: CurrentWeather) {
        currentViewModel = CurrentViewModel(currentWeather: data)
    }
}
