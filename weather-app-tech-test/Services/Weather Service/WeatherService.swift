//
//  WeatherService.swift
//  weather-app-tech-test
//
//  Created by Russell Warwick on 15/12/2022.
//

import Foundation
import Combine

enum WeatherError: Error {
    case failed
    
    var message: String {
        switch self {
            case .failed:
                return "Failed to fetch weather. Please check connection and try again"
        }
    }
}

protocol WeatherServiceType {
    func getCurrent(coord: Coordinates) -> AnyPublisher<Forecast, Error>
    func getForecast(coord: Coordinates) -> AnyPublisher<[Forecast], Error>
}

final class WeatherService: WeatherServiceType {
    
    private let network: NetworkLayerType
    
    init(network: NetworkLayerType = NetworkLayer()) {
        self.network = network
    }
    
    func getCurrent(coord: Coordinates) -> AnyPublisher<Forecast, Error> {
        network.request(WeatherEndpoint.getCurrent(coord: coord), forModel: Forecast.self)
        .mapError { _ in WeatherError.failed }
        .eraseToAnyPublisher()
    }
    
    func getForecast(coord: Coordinates) -> AnyPublisher<[Forecast], Error> {
        network.request(WeatherEndpoint.getForecast(coord: coord), forModel: ForecastWeek.self)
        .map { $0.list }
        .mapError { _ in WeatherError.failed }
        .eraseToAnyPublisher()
    }
}
