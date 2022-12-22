//
//  Helper.swift
//  weather-app-tech-testTests
//
//  Created by Russell Warwick on 16/12/2022.
//

import XCTest
@testable import weather_app_tech_test

extension XCTestCase {
    
    enum Files: String {
        case current = "current-weather"
        case forecast = "forecast"
    }
    
    func getData(fromFile file: Files) -> Data {
        let bundle = Bundle(for: type(of: self))

        guard let url = bundle.url(forResource: file.rawValue, withExtension: "json") else {
            fatalError("Failed to load \(file.rawValue) from bundle.")
        }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            fatalError("Failed to get contents of \(file.rawValue)")
        }
    }
}
