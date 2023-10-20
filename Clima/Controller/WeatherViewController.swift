//
//  ViewController.swift
//  Clima
//
//  Created by José Manuel Malagon Alba on 25/09/2023.
//  Copyright © 2023 App Clima. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    //MARK: - Properties
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchTextField.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        
        // Pop up for user permison
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    
    //MARK: - Actions
    
    @IBAction func searchPressed(button: UIButton) {
        cityLabel.text = searchTextField.text
        searchTextField.endEditing(true)
    }
    
    @IBAction func locationButtonPressed(_ : UIButton) {
        locationManager.requestLocation()
    }

}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cityLabel.text = searchTextField.text
        searchTextField.endEditing(true)
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let cityName = textField.text else { return }
        
        weatherManager.fetchWeather(ByCityName: cityName)
        searchTextField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }
        
        searchTextField.placeholder = "Search for a city"
        return false
    }
}

//MARK: - WeatherDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weather: WeatherModel) {
        cityLabel.text = weather.cityName
        conditionImageView.image = UIImage(systemName: weather.conditionName)
        temperatureLabel.text = weather.temperaturaString
    }
    
    func didFail(with error: Error) {
        print(error)
    }
}

//MARK: - CCLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            manager.stopUpdatingLocation()
            weatherManager.fetchWeather(ByCoordinates: Coordinates(latitude: currentLocation.coordinate.latitude,
                                                                   longitude: currentLocation.coordinate.longitude))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
