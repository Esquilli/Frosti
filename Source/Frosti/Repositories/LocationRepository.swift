//
//  LocationRepository.swift
//  Frosti
//
//  Created by Pedro Fernandez on 1/11/22.
//

import Combine
import CoreLocation
import Foundation

protocol LocationRepositoryProtocol: AnyObject {
    func requestWhenInUseAuthorization() -> Future<Void, LocationError>
    func getCurrentLocation() -> Future<CLLocation, LocationError>
}

final class LocationRepository: LocationRepositoryProtocol {
    private let locationService: LocationServiceProtocol
    
    init(locationService: LocationServiceProtocol = LocationService()) {
        self.locationService = locationService
        self.setup()
    }
    
    func setup() {
        // No-op
    }
    
    func requestWhenInUseAuthorization() -> Future<Void, LocationError> {
        return locationService.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation() -> Future<CLLocation, LocationError> {
        return locationService.requestLocation()
    }
    
}
