//
//  LocationServiceMock.swift
//  weather-app-tech-testTests
//
//  Created by Russell Warwick on 20/12/2022.
//

import Combine
import XCTest
@testable import weather_app_tech_test

class LocationServiceMock: LocationServiceType {
    
    var coordinates: Coordinates?
    var error: LocationError = .noLocationFound
    
    func fetchLocation() -> AnyPublisher<Coordinates, Error> {
        if let coordinates = coordinates {
            return Just(coordinates)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}
