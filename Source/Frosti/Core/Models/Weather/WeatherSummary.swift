//
//  WeatherSummary.swift
//  Frosti
//
//  Created by Pedro Fernandez on 1/10/22.
//

import Foundation
import SwiftUI

struct WeatherSummary {
    let city: String
    let lat, lon: Double
    var current: CurrentWeatherSummary
    let daily: [DailyWeatherSummary]
    
    static func convert(from data: WeatherOneCallResponse, city: String) -> WeatherSummary {
        return WeatherSummary(city: city,
                              lat: data.lat,
                              lon: data.lon,
                              current: CurrentWeatherSummary.convert(from: data.current, city: city),
                              daily: data.daily.map { .convert(from: $0, city: city) })
    }
}

struct CurrentWeatherSummary {
    let city: String
    let time: Date
    let temp, feelsLike: Measurement<UnitTemperature>
    let description: [WeatherDetails]
    
    static func convert(from data: WeatherCurrent, city: String) -> CurrentWeatherSummary {
        return CurrentWeatherSummary(city: city,
                                     time: Date(timeIntervalSince1970: TimeInterval(data.dt)),
                                     temp: Measurement(value: data.temp, unit: AppConfig.defaultTemperatureUnit),
                                     feelsLike: Measurement(value: data.feelsLike, unit: AppConfig.defaultTemperatureUnit),
                                     description: data.weather.map { WeatherDetails.convert(from: $0) })
    }
}

struct DailyWeatherSummary {
    let city: String
    let time: Date
    let minTemp, maxTemp: Measurement<UnitTemperature>
    let description: [WeatherDetails]
    
    static func convert(from data: WeatherDaily, city: String) -> DailyWeatherSummary {
        return DailyWeatherSummary(city: city,
                                   time: Date(timeIntervalSince1970: TimeInterval(data.dt)),
                                   minTemp: Measurement(value: data.temp.min, unit: AppConfig.defaultTemperatureUnit),
                                   maxTemp: Measurement(value: data.temp.max, unit: AppConfig.defaultTemperatureUnit),
                                   description: data.weather.map { WeatherDetails.convert(from: $0) })
    }
}

struct WeatherDetails {
    let weatherCondition, weatherDescription, weatherIconId: String
    var weatherIcon: Image {
        switch weatherIconId {
        case "01d": return Image(systemName: "sun.max")
        case "01n": return Image(systemName: "moon")
        case "02d": return Image(systemName: "cloud.sun")
        case "02n": return Image(systemName: "cloud.moon")
        case "03d", "03n", "04d", "04n": return Image(systemName: "cloud")
        case "09d", "09n": return Image(systemName: "cloud.rain")
        case "10d": return Image(systemName: "cloud.sun.rain")
        case "10n": return Image(systemName: "cloud.moon.rain")
        case "11d", "11n": return Image(systemName: "cloud.bolt.rain")
        case "13d", "13n": return Image(systemName: "cloud.snow")
        case "50d", "50n": return Image(systemName: "cloud.fog")
        default: return Image(systemName: "sun.max")
        }
    }
    
    static func convert(from data: Weather) -> Self {
        return WeatherDetails(weatherCondition: data.main,
                              weatherDescription: data.weatherDescription,
                              weatherIconId: data.icon)
    }
}

extension WeatherSummary {
    static func fake() -> WeatherSummary {
        let path = Bundle.main.path(forResource: "MockWeatherOneCallResponse", ofType: "json")!
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        let response = try! JSONDecoder().decode(WeatherOneCallResponse.self, from: data)
        return WeatherSummary.convert(from: response, city: "Wooster")
    }
}
