//
//  CurrentWeatherViewModel.swift
//  Frosti
//
//  Created by Pedro Fernandez on 1/10/22.
//

import SwiftUI

class CurrentWeatherViewModel: ObservableObject {
    private let currentWeather: CurrentWeatherSummary?
    
    init(currentWeather: CurrentWeatherSummary?) {
        self.currentWeather = currentWeather
    }
    
    var currentWeatherIcon: Image? {
        currentWeather?.description.first?.weatherIcon
    }
    
    var currentTemp: String {
        guard let currentWeather = currentWeather else { return "--°"}
        return String(format: "%.0f°", currentWeather.temp.value)
    }
    
    var currentCity: String {
        guard let currentWeather = currentWeather else { return "--"}
        return currentWeather.city
    }
    
    var currentWeatherDescription: String {
        guard let currentWeather = currentWeather else { return "--"}
        guard let description = currentWeather.description.first?.weatherDescription else { return "--" }
        return description
    }
    
    var currentFeelsLike: String {
        guard let currentWeather = currentWeather else { return "--"}
        return String(format: "Feels like %.0f°", currentWeather.feelsLike.value)
    }
    
}
