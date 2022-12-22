//
//  Endpoint.swift
//  weather-app-tech-test
//
//  Created by Russell Warwick on 15/12/2022.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var method: String { get }
    var parameters: [String: Any] { get }
}
 
extension EndPointType {
    func buildRequest() -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                   timeoutInterval: 5.0)
        
        request.httpMethod = method
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0, value: "\($1)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)) }
            request.url = urlComponents.url
        }

        return request
    }
}
