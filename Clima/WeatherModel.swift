//
//  WeatherModel.swift
//  Clima
//
//  Created by José Manuel Malagón Alba on 25/9/23.
//  Copyright © 2023 App Clima. All rights reserved.
//

import Foundation

struct WeatherModel {
    
    //MARK: - Properties
    
    let conditionId: Int
    let cityName: String
    let temperature: Double
    var temperaturaString: String { String(format: "%.1f", temperature) }
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    //MARK: - Functions
    
    
}
