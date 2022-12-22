//
//  WeatherServiceMock.swift
//  weather-app-tech-testTests
//
//  Created by Russell Warwick on 16/12/2022.
//

import Combine
import XCTest
@testable import weather_app_tech_test

class WeatherServiceMock: WeatherServiceType {
    
    var getCurrentData: Forecast?
    var getForcastData: [Forecast]?
    
    func getCurrent(coord: Coordinates) -> AnyPublisher<Forecast, Error> {
        if let getCurrentData = getCurrentData {
            return Just(getCurrentData)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: WeatherError.failed)
                .eraseToAnyPublisher()
        }
    }
    
    func getForecast(coord: Coordinates) -> AnyPublisher<[Forecast], Error> {
        if let getForcastData = getForcastData {
            return Just(getForcastData)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: WeatherError.failed)
                .eraseToAnyPublisher()
        }
    }
}
