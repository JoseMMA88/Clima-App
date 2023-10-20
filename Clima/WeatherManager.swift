//
//  WeatherManager.swift
//  Clima
//
//  Created by José Manuel Malagon Alba on 25/09/2023.
//  Copyright © 2023 App Clima. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weather: WeatherModel)
    func didFail(with error: Error)
}

struct Coordinates {
    let latitude: Double
    let longitude: Double
}

struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=d0a98e002d74a8214c2789eaec7e0638&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(ByCityName city: String) {
        let url = "\(weatherUrl)&q=\(city)"
        performRequest(with: url)
    }
    
    func fetchWeather(ByCoordinates coordinates: Coordinates) {
        let url = "\(weatherUrl)&lat=\(coordinates.latitude)&lon=\(coordinates.longitude)"
        performRequest(with: url)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    self.delegate?.didFail(with: error)
                }
                
                if let safeDate = data {
                    if let weather = self.parseJson(weatherData: safeDate) {
                        DispatchQueue.main.async {
                            self.delegate?.didUpdateWeather(weather)
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJson(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let weatherData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = weatherData.weather[0].id
            let temperature = weatherData.main.temp
            let name = weatherData.name
            
            return WeatherModel(conditionId: id,
                                cityName: name,
                                temperature: temperature)
            
        } catch {
            self.delegate?.didFail(with: error)
            return nil
        }
    }
    
}
