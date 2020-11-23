//
//  WeatherRepositoryProtocol.swift
//  Weather
//
//  Created by 1234 on 22.11.2020.
//

import Foundation

protocol WeatherRepositoryProtocol {
    
    @discardableResult
    func forecastShort(city: CityModel, responseHandler: @escaping (WeatherModel?, Error?) -> Void) -> NetworkProtocol.NetworkRequest
    @discardableResult
    func forecastFull(city: CityModel, responseHandler: @escaping (WeatherModel?, Error?) -> Void) -> NetworkProtocol.NetworkRequest
    
    func cancelRequestForCity(city: CityModel)
}

