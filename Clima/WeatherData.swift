//
//  WeatherData.swift
//  Clima
//
//  Created by José Manuel Malagón Alba on 25/9/23.
//  Copyright © 2023 App Clima. All rights reserved.
//

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
}
