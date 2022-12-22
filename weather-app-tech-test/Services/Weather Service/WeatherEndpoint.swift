//
//  WeatherEndpoint.swift
//  weather-app-tech-test
//
//  Created by Russell Warwick on 15/12/2022.
//

import Foundation

enum WeatherEndpoint {
    case getCurrent(coord: Coordinates)
    case getForecast(coord: Coordinates)
}

extension WeatherEndpoint: EndPointType {

    var method: String {
        "GET"
    }
        
    var baseURL: URL {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/") else { fatalError("Invalid base URL") }
        return url
    }
    
    var path: String {
        switch self {
            case .getCurrent(_):
                return "weather"
            case .getForecast(_):
                return "forecast"
        }
    }

    var parameters: [String: Any] {
        switch self {
            case .getCurrent(let coord):
                return ["lat": coord.lat,
                        "lon": coord.lon,
                        "units": "metric",
                        "appid": "9d63b194e4cd78a327a505e16a120a6f"]
            case .getForecast(let coord):
                return["lat": coord.lat,
                       "lon": coord.lon,
                       "units": "metric",
                       "appid": "9d63b194e4cd78a327a505e16a120a6f"]
        }
    }
}
