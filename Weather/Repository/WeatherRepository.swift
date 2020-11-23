//
//  WeatherApiService.swift
//  Weather
//
//  Created by 1234 on 22.11.2020.
//

import Foundation


class WeatherRepository: WeatherRepositoryProtocol {
    // MARK: - Dependency
    private var network: NetworkProtocol!
    
    // MARK: - Settings
    private let apiKey = "61f16320-de81-46f3-a219-a1e012028a3f"
    private let apiUrl = "https://api.weather.yandex.ru/v2/"
    private var authHeader: [String: String] {
        return ["X-Yandex-API-Key": apiKey]
    }
    
    private enum apiEndPoints: String {
        case forecast = "forecast"
    }
    
    // MARK: - Variables
    private var requests = Dictionary<Int, NetworkProtocol.NetworkRequest>()
    
    
    // MARK: - Functions
    init(network: NetworkProtocol?) {
        self.network = network!
    }
    
    deinit {
        onDispose()
    }

    public func forecastShort(city: CityModel, responseHandler: @escaping (WeatherModel?, Error?) -> Void) -> NetworkProtocol.NetworkRequest {
        
        let url = String.init(format: "%@%@", apiUrl, apiEndPoints.forecast.rawValue)
        let params = ["lat": "\(city.lat)",
                      "lon": "\(city.lon)",
                      "lang": Locale.current.identifier,
                      "limit": "7",
                      "hours": "false",
                      "extra": "false"
                     ]
        
        requests[city.id] = network.getRequest(url, params: params, headers: authHeader) { (data: WeatherModel?, error: Error?) in
            responseHandler(data, error)
        }
        
        return requests[city.id]!
    }
    
    public func forecastFull(city: CityModel, responseHandler: @escaping (WeatherModel?, Error?) -> Void) -> NetworkProtocol.NetworkRequest {
        
        let url = String.init(format: "%@%@", apiUrl, apiEndPoints.forecast.rawValue)
        let params = ["lat": "\(city.lat)",
                      "lon": "\(city.lon)",
                      "lang": Locale.current.identifier,
                      "limit": "7",
                      "hours": "false",
                      "extra": "false"
                     ]
        
        requests[city.id] = network.getRequest(url, params: params, headers: authHeader) { (data: WeatherModel?, error: Error?) in
            responseHandler(data, error)
        }
        
        return requests[city.id]!
    }
    
    public func cancelRequestForCity(city: CityModel) {
        
        if let request = requests[city.id], network.isRequestWorking(request: request) {
            network.cancelRequest(request: request)
        }
    }
    
    
    public func onDispose() {
        
        requests.forEach { (request) in
            if (network.isRequestWorking(request: request)) {
                network.cancelRequest(request: request)
            }
        }
    }
    
    
}
