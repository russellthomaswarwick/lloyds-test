//
//  WeatherViewModelTests.swift
//  weather-app-tech-testTests
//
//  Created by Russell Warwick on 20/12/2022.
//

import Foundation
import Combine
import XCTest

@testable import weather_app_tech_test

class WeatherViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    
    var weatherMock: WeatherServiceMock!
    var locationMock: LocationServiceMock!
    
    override func setUp() async throws {
        cancellables = []
        weatherMock = WeatherServiceMock()
        locationMock = LocationServiceMock()
    }
    
    func testViewDidLoad_whenServicesGetsValidData_feedPublisherGetsCalled() {
        locationMock.coordinates = .init(lat: 42.2, lon: 42.2)
        weatherMock.getCurrentData = try? JSONDecoder().decode(Forecast.self, from: getData(fromFile: .current))
        weatherMock.getForcastData = try? JSONDecoder().decode(ForecastWeek.self, from: getData(fromFile: .forecast)).list
        
        let sut = WeatherViewModel(weatherService: weatherMock, locationService: locationMock)
        let expectation = self.expectation(description: "Should call feed sink")
        
        var currentForecast: Forecast?
        var weeklyForecast = [Forecast]()
        
        sut.feedPublisher.sink { (current, forecast) in
            currentForecast = current
            weeklyForecast = forecast
            expectation.fulfill()
        }.store(in: &cancellables)
        
        sut.viewDidLoad()
        
        waitForExpectations(timeout: 10)
        
        XCTAssertNotNil(currentForecast)
        XCTAssertEqual(weeklyForecast.count, 40)
    }
    
    func testViewDidLoad_whenWeatherServiceFailsToGetData_errorPublisherGetsCalled() {
        locationMock.coordinates = .init(lat: 42.2, lon: 42.2)
        weatherMock.getCurrentData = try? JSONDecoder().decode(Forecast.self, from: getData(fromFile: .current))
        weatherMock.getForcastData = nil
        
        let sut = WeatherViewModel(weatherService: weatherMock, locationService: locationMock)
        let expectation = self.expectation(description: "Should call error sink")
        
        var errorFound: String?
        
        sut.errorPublisher.sink { _ in
            expectation.fulfill()
        } receiveValue: { errorText in
            if let errorText = errorText {
                errorFound = errorText
                expectation.fulfill()
            }
        }.store(in: &cancellables)

        sut.viewDidLoad()
        
        wait(for: [expectation], timeout: 10.0)
        
        XCTAssertEqual(errorFound, "Failed to fetch weather. Please check connection and try again")
    }
    
    func testViewDidLoad_whenLocationServicesFailToGetData_errorPublisherGetsCalled() {
        weatherMock.getCurrentData = try? JSONDecoder().decode(Forecast.self, from: getData(fromFile: .current))
        weatherMock.getForcastData = try? JSONDecoder().decode(ForecastWeek.self, from: getData(fromFile: .forecast)).list
        
        let sut = WeatherViewModel(weatherService: weatherMock, locationService: locationMock)
        let expectation = self.expectation(description: "Should call error sink")
        
        var errorFound: String?
        
        sut.errorPublisher.sink { _ in
            expectation.fulfill()
        } receiveValue: { errorText in
            if let errorText = errorText {
                errorFound = errorText
                expectation.fulfill()
            }
        }.store(in: &cancellables)

        sut.viewDidLoad()
        
        wait(for: [expectation], timeout: 10.0)
        
        XCTAssertEqual(errorFound, "Cannot find location.")
    }
}
