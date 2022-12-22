//
//  ForecastViewModel.swift
//  weather-app-tech-test
//
//  Created by Russell Warwick on 20/12/2022.
//

import Foundation

struct ForecastViewModel {
    let forecast: Forecast
    let dateFormatter = WeatherDateFormatter()
    
    var dateText: String {
        dateFormatter.getDate(timeInterval: Double(forecast.dt))
    }
    
    var conditionsText: String? {
        forecast.weather.first?.title
    }

    var tempText: String {
        String(format: "%.0f°", forecast.details.temp)
    }
    
    var highTempText: String {
        String(format: "H: %.0f°", forecast.details.tempMax)
    }
    
    var lowTempText: String {
        String(format: "L: %.0f°", forecast.details.tempMin)
    }
}
