//
//  WeatherViewModel.swift
//  weather-app-tech-test
//
//  Created by Russell Warwick on 16/12/2022.
//

import Foundation
import Combine

final class WeatherViewModel {
    
    // MARK: Combine
    
    private var cancellables = Set<AnyCancellable>()
    private var errorSubject = PassthroughSubject<String?, Never>()
    private var feedSubject = PassthroughSubject<(Forecast, [Forecast]), Never>()
    private var isLoadingSubject = PassthroughSubject<Bool, Never>()
    
    // MARK: Dependencies
    
    private let weatherService: WeatherServiceType
    private let locationService: LocationServiceType
    
    // MARK: Init
    
    init(weatherService: WeatherServiceType = WeatherService(),
         locationService: LocationServiceType = LocationService()) {
        self.weatherService = weatherService
        self.locationService = locationService
    }
    
    // MARK: Interface
    
    var errorPublisher: AnyPublisher<String?, Never> {
        errorSubject
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    var feedPublisher: AnyPublisher<(Forecast, [Forecast]), Never> {
        feedSubject
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        isLoadingSubject
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        refresh()
    }
    
    func refresh(showLoading: Bool = true) {
        if showLoading {
            isLoadingSubject.send(true)
        }
        fetchData()
    }
    
    // MARK: Private
    
    private func fetchData() {
        errorSubject.send(nil)
        locationService.fetchLocation().flatMap { [unowned self] coords in
            Publishers.Zip(self.weatherService.getCurrent(coord: coords),
                           self.weatherService.getForecast(coord: coords))
        }.sink { [weak self] completion in
            guard let self = self else { return }
            self.isLoadingSubject.send(false)
            if case let .failure(error) = completion {
                if let error = error as? LocationError {
                    self.errorSubject.send(error.message)
                } else if let error = error as? WeatherError {
                    self.errorSubject.send(error.message)
                } else {
                    self.errorSubject.send("An error occured")
                }
            }
        } receiveValue: { [weak self] (forecast, weekly) in
            self?.errorSubject.send(nil)
            self?.isLoadingSubject.send(false)
            self?.feedSubject.send((forecast, weekly))
        }.store(in: &cancellables)
    }
}
