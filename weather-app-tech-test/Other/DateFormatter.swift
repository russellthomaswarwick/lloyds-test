//
//  DateFormatter.swift
//  weather-app-tech-test
//
//  Created by Russell Warwick on 20/12/2022.
//

import Foundation

struct WeatherDateFormatter {
    func getDate(timeInterval: Double) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E d MMM • ha"
        return dateFormatter.string(from: date)
    }
    
    func getTime(timeInterval: Double) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        return dateFormatter.string(from: date)
    }
}
