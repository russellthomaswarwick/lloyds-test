//
//  LocationService.swift
//  weather-app-tech-test
//
//  Created by Russell Warwick on 16/12/2022.
//

import Foundation
import Combine
import CoreLocation

enum LocationError: Error {
    case denied
    case noLocationFound
    
    var message: String {
        switch self {
            case .noLocationFound:
                return "Cannot find location."
            case .denied:
               return "Cannot access location services. Please enable in settings."
        }
    }
}

protocol LocationServiceType {
    func fetchLocation() -> AnyPublisher<Coordinates, Error>
}

final class LocationService: NSObject, LocationServiceType {
    
    private let locationManager: CLLocationManager
    private var coordinatesSubject = PassthroughSubject<Coordinates, Error>()

    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func fetchLocation() -> AnyPublisher<Coordinates, Error> {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        return coordinatesSubject
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinatesObject = manager.location?.coordinate else {
            coordinatesSubject.send(completion: .failure(LocationError.noLocationFound))
            return
        }
        coordinatesSubject.send(.init(lat: Double(coordinatesObject.latitude),
                                      lon: Double(coordinatesObject.longitude)))
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        switch locationManager.authorizationStatus {
            case .denied, .restricted:
                coordinatesSubject.send(completion: .failure(LocationError.denied))
            default:
                break
        }
        coordinatesSubject.send(completion: .failure(LocationError.noLocationFound))
    }
}
