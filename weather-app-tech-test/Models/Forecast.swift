//
//  Forecast.swift
//  weather-app-tech-test
//
//  Created by Russell Warwick on 16/12/2022.
//

import Foundation

struct ForecastWeek: Codable {
    let list: [Forecast]
}

// MARK: - List
struct Forecast: Codable {
    
    let dt: Int
    let details: WeatherDetails
    let weather: [Weather]
    let name: String?

    enum CodingKeys: String, CodingKey {
        case dt, weather, name
        case details = "main"
    }
}

extension Forecast: Hashable {
    static func == (lhs: Forecast, rhs: Forecast) -> Bool {
        lhs.dt == rhs.dt
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(dt)
    }
}

struct WeatherDetails: Codable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct Weather: Codable {
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case title = "main"
    }
}
