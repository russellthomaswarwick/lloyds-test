//
//  NetworkLayer.swift
//  weather-app-tech-test
//
//  Created by Russell Warwick on 15/12/2022.
//

import Foundation
import Combine

enum RequestError: Error {
    case clientError
    case serverError(code: Int)
    case noResponse
}

protocol NetworkLayerType {
    func request<T: Decodable>(_ endpoint: EndPointType, forModel model: T.Type) -> AnyPublisher<T, Error>
}

final class NetworkLayer: NetworkLayerType {
    
    private let urlSession: URLSession
    
    // MARK: Init
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    // MARK: NetworkLayerType
    
    func request<T: Decodable>(_ endpoint: EndPointType, forModel model: T.Type) -> AnyPublisher<T, Error> {
        
        let request = endpoint.buildRequest()
        
        return urlSession.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw RequestError.noResponse
                }
                
                switch httpResponse.statusCode {
                    case 200...299:
                        return data
                    case 400...499:
                        throw RequestError.clientError
                    default:
                        throw RequestError.serverError(code: httpResponse.statusCode)
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
