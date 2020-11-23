//
//  CityRepositoryProtocol.swift
//  Weather
//
//  Created by 1234 on 22.11.2020.
//

import Foundation

protocol CityRepositoryProtocol {
    
    func getCities(completionHandler: @escaping ([CityModel], Error?) -> Void ) -> Void
}
