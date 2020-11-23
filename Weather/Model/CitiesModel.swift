//
//  CitiesModel.swift
//  Weather
//
//  Created by 1234 on 22.11.2020.
//

import Foundation

// MARK: - Submodels
struct CityModel: Identifiable, Decodable {
    
    var id: Int
    var name: [String: String]
    var lat: Float
    var lon: Float
}

// MARK: - Main Model
struct CitiesModel: Decodable {
    
    var cities: [CityModel]
}

// MARK: - Extensions Methods
extension CityModel {
    
    func getNameByLocale(locale: String?, defaultLocaleCode: String = "en") -> String {
        
        let localeToUse = locale ?? defaultLocaleCode
                
        if self.name.keys.contains(where: { key in key == localeToUse}) {
            return self.name[localeToUse] ?? self.name[defaultLocaleCode] ?? self.name.first?.value ?? ""
        } else {
            return self.name[defaultLocaleCode] ?? self.name.first?.value ?? ""
        }
    }
}
