//
//  WeatherOneCallResponse.swift
//  Frosti
//
//  Created by Pedro Fernandez on 1/10/22.
//

import Foundation

struct WeatherOneCallResponse: Codable {
    let lat, lon: Double
    let timezone: String
    let current: WeatherCurrent
    let daily: [WeatherDaily]
}

struct WeatherCurrent: Codable {
    let dt, sunrise, sunset: Int
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint: Double
    let uvi, clouds, visibility: Double
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
    }
}

struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

struct WeatherDaily: Codable {
    let dt, sunrise, sunset, moonrise: Int
    let moonset: Int
    let moonPhase: Double
    let temp: WeatherTemp
    let feelsLike: WeatherFeelsLike
    let pressure, humidity: Int
    let dewPoint, windSpeed: Double
    let windDeg: Int
    let windGust: Double
    let weather: [Weather]
    let clouds: Int
    let pop, uvi: Double
    let snow: Double?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, uvi, snow
    }
}

struct WeatherFeelsLike: Codable {
    let day, night, eve, morn: Double
}

struct WeatherTemp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}
