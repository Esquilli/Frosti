//
//  NewsWebRepository.swift
//  Newsi
//
//  Created by Pedro Fernandez on 1/6/22.
//

import Combine
import CoreLocation
import Foundation

protocol WeatherWebRepositoryProtocol: AnyObject {
    func getWeather(lat: CLLocationDegrees, lon: CLLocationDegrees, unit: String) -> AnyPublisher<WeatherOneCallResponse, Error>
}

final class WeatherWebRepository: WeatherWebRepositoryProtocol {
    private let networker: NetworkServiceProtocol
    
    init(networker: NetworkServiceProtocol = NetworkService()) {
        self.networker = networker
    }
    
    func getWeather(lat: CLLocationDegrees, lon: CLLocationDegrees, unit: String) -> AnyPublisher<WeatherOneCallResponse, Error> {
        let endpoint = Endpoint.Weather.weather(lat: lat, lon: lon, unit: unit)
        
        return networker.get(type: WeatherOneCallResponse.self, url: endpoint.url, headers: endpoint.headers)
    }
}
