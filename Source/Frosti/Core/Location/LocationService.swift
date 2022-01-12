//
//  LocationService.swift
//  Frosti
//
//  Created by Pedro Fernandez on 1/10/22.
//

import Combine
import CoreLocation
import Foundation

protocol LocationServiceProtocol: AnyObject {
    func requestWhenInUseAuthorization() -> Future<Void, LocationError>
    func requestLocation() -> Future<CLLocation, LocationError>
}

final class LocationService: NSObject, LocationServiceProtocol {
    private let locationManager = CLLocationManager()
    private var location: CLLocation?
    
    private var authorizationRequests: [(Result<Void, LocationError>) -> Void] = []
    private var locationRequests: [(Result<CLLocation, LocationError>) -> Void] = []
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func requestWhenInUseAuthorization() -> Future<Void, LocationError> {
        guard locationManager.authorizationStatus == .notDetermined else {
            return Future { $0(.success(())) }
        }

        let future = Future<Void, LocationError> { completion in
            self.authorizationRequests.append(completion)
        }
        
        locationManager.requestWhenInUseAuthorization()

        return future
    }

    func requestLocation() -> Future<CLLocation, LocationError> {
        guard locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse
        else {
            return Future { $0(.failure(LocationError.unauthorized)) }
        }

        let future = Future<CLLocation, LocationError> { completion in
            self.locationRequests.append(completion)
        }

        locationManager.requestLocation()

        return future
    }
    
    private func handleLocationRequestResult(_ result: Result<CLLocation, LocationError>) {
        while locationRequests.count > 0 {
            let request = locationRequests.removeFirst()
            request(result)
        }
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus{
        case .notDetermined:
            manager.requestWhenInUseAuthorization() // TODO: may not be the right way
        case .restricted:
            print("Your location is restricted (parental controls?")
        case .denied:
            print("The app does not have location permissions. Please enable them in settings")
        case .authorizedAlways, .authorizedWhenInUse:
            print("The app is authorized to receive locations.")
        @unknown default:
            print("Unknown issue")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let locationError: LocationError
        if let error = error as? CLError, error.code == .denied {
            locationError = .unauthorized
        } else {
            locationError = .unableToDetermineLocation
        }
        
        handleLocationRequestResult(.failure(locationError))
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            handleLocationRequestResult(.success(location))
            manager.stopUpdatingLocation()
        }
    }
}
