//
//  NewsFeedViewModel.swift
//  Newsi
//
//  Created by Pedro Fernandez on 1/7/22.
//

import Combine
import Foundation
import CoreLocation

class HomeViewModel: NSObject, ObservableObject {
    @Published var state: LoadingState = .loading
    
    private var weather: WeatherSummary?
    private var cancellables = Set<AnyCancellable>()
    private let weatherRepository: WeatherWebRepositoryProtocol
    private let locationRepository: LocationRepositoryProtocol
    private var currentLocation: CLLocation?
    private var currentPlacemark: CLPlacemark?
    
    init(weatherRepository: WeatherWebRepositoryProtocol, locationRepository: LocationRepositoryProtocol) {
        self.weatherRepository = weatherRepository
        self.locationRepository = locationRepository
    }
    
    func load() {
        state = .loading
        self.getLocation()
    }
    
    private func getLocation() {
        locationRepository.requestWhenInUseAuthorization()
        .flatMap { self.locationRepository.getCurrentLocation() }
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self.state = .failed(error)
            }

        } receiveValue: { [weak self] location in
            self?.currentLocation = location
            self?.getWeather(location: location)
        }
        .store(in: &cancellables)
    }
    
    private func getWeather(location: CLLocation) {
        weatherRepository.getWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude, unit: AppConfig.defaultTemperatureUnit.toString())
        .receive(on: DispatchQueue.main)
        .sink { completion in
            print(completion)
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self.state = .failed(error)
            }
            
        } receiveValue: { [weak self] data in
            guard let currentLocation = self?.currentLocation else {
                self?.state = .failed(LocationError.unableToDetermineLocation)
                return
            }

            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
                
                guard let placemark = placemarks?.first, let currentCity = placemark.locality else { return }
                self?.currentPlacemark = placemark
                self?.weather = WeatherSummary.convert(from: data, city: currentCity)
                self?.state = .success
            }
        }
        .store(in: &cancellables)
    }
    
    func currentWeatherViewModel() -> CurrentWeatherViewModel? {
        guard let weather = weather else { return nil }
        return .init(currentWeather: weather.current)
    }
}

extension UnitTemperature {
    func toString() -> String {
        switch self {
        case .celsius:
            return "metric"
        case .fahrenheit:
            return "imperial"
        default:
            return "kelvin"
        }
    }
}
