//
//  WeatherModel.swift
//  Weather
//
//  Created by 1234 on 22.11.2020.
//

import Foundation

// MARK: - Submodels
struct TimeZoneInfoModel: Decodable {
    
    var offset: Int
    var name: String
    var abbr: String
    var dst: Bool
}

struct InfoModel: Decodable {
    
    var lat: Float
    var lon: Float
    var tzinfo: TimeZoneInfoModel
    var def_pressure_mm: Int
    var def_pressure_pa: Int
    var url: URL
}

struct CurrentWeatherModel: Decodable {
    
    var temp: Int
    var feels_like: Int
    var temp_water: Int?
    var icon: String
    var condition: String
    var wind_speed: Float
    var wind_gust: Float?
    var wind_dir: String
    var pressure_mm: Int
    var pressure_pa: Int
    var humidity: Int
    var daytime: String
    var polar: Bool
    var season: String
    var prec_type: Int?
    var prec_strenght: Float?
    var is_thunder: Bool?
    var cloudness: Float?
    var obs_time: TimeInterval
    var phemom_icon: String?
    var phemom_condition: String?
}

struct ForecastPartModel: Decodable {
    
    var temp: Int?
    var temp_min: Int?
    var temp_max: Int?
    var temp_avg: Int?
    var feels_like: Int
    var icon: String
    var condition: String
    var daytime: String?
    var polar: Bool?
    var wind_speed: Float
    var wind_gust: Float?
    var wind_dir: String
    var pressure_mm: Int
    var pressure_pa: Int
    var humidity: Int
    var prec_mm: Float
    var prec_period: Int?
    var prec_type: Int?
    var prec_strength: Float?
    var cloudness: Float?
}

struct ForecastModel: Decodable {
    
    var date: String
    var date_ts: Int
    var week: Int
    var sunrise: String
    var sunset: String
    var moon_code: Int
    var moon_text: String
    var parts: [String: ForecastPartModel]
}

// MARK: - Error Model
struct WeatherErrorModel: Decodable {
    
    var status: Int
    var message: String
}


// MARK: - Main Model
struct WeatherModel: Decodable {
    
    var now: Date
    var now_dt: String
    var info: InfoModel
    var fact: CurrentWeatherModel
    var forecasts: Array<ForecastModel>
}
