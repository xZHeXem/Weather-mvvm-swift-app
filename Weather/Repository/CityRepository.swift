//
//  LocalDataRepository.swift
//  Weather
//
//  Created by 1234 on 22.11.2020.
//

import Foundation

class CityRepository: CityRepositoryProtocol {
    
    // MARK: - Settings
    private let fileName = "cities"
    
    // MARK: - Variables
    public func getCities(completionHandler: @escaping ([CityModel], Error?) -> Void ) -> Void  {
        
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data   = try Data(contentsOf: url)
                let cities = try self.decodeCities(data)
                completionHandler(cities, nil)
            } catch {
                completionHandler([], error)
            }
        }
    }
    
    fileprivate func decodeCities(_ data: Data) throws -> [CityModel] {
        
        let decoder = JSONDecoder()
        let jsonData = try decoder.decode(CitiesModel.self, from: data)
        return jsonData.cities
    }
}
