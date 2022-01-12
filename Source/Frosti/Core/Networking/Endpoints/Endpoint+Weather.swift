//
//  Endpoint+News.swift
//  Newsi
//
//  Created by Pedro Fernandez on 1/6/22.
//

import Combine
import Foundation

extension Endpoint {
    struct Weather: EndpointProtocol {
        var path: String
        var queryItems: [URLQueryItem] = []
        private static let newsApiKey = "<YOUR API KEY HERE>"
        
        var url: URL {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.openweathermap.org"
            components.path = "/data/2.5" + path
            components.queryItems = queryItems
            
            guard let url = components.url else {
                preconditionFailure("Invalid URL components: \(components)")
            }
            
            return url
        }
        
        var headers: [String: Any] {
            return [:]
        }
    }
}

extension Endpoint.Weather {
    static func weather(lat: Double, lon: Double, unit: String) -> Self {
        return Endpoint.Weather(path: "/onecall",
                                queryItems: [
                                    URLQueryItem(name: "lat", value: String(lat)),
                                    URLQueryItem(name: "lon", value: String(lon)),
                                    URLQueryItem(name: "apiKey", value: newsApiKey),
                                    URLQueryItem(name: "units", value: unit),
        ])
    }
}
#imageLiteral(resourceName: "simulator_screenshot_22BBCBE6-5047-4514-8D8B-836AECEE16DC.png")
