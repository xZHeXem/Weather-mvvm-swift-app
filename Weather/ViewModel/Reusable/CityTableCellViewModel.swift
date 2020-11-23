//
//  MasterTableCellViewModel.swift
//  Weather
//
//  Created by 1234 on 22.11.2020.
//

import Foundation
import RxSwift
import RxCocoa

class CityTableCellViewModel {

    // MARK: - Variables
    fileprivate let locale = Locale.preferredLocale().languageCode
    
    // MARK: - Relay
    private let _name = BehaviorRelay<String>(value: "")
    private let _weather = BehaviorRelay<WeatherModel?>(value: nil)
    private let disposeBag = DisposeBag()
    
    // MARK: - Drivers
    public var name: Driver<String> {
        
        return _name.asDriver()
    }
    
    public var weather: Driver<WeatherModel?> {
        
        return _weather.asDriver()
    }
    
    // MARK: - Functions
    init(city: CityModel, weather: Driver<Dictionary<Int, WeatherModel>>) {
        
        let cityName = city.getNameByLocale(locale: locale)
        _name.accept( cityName )        
        
        weather.drive { [weak self] (weather: Dictionary<Int, WeatherModel>) in
            self?._weather.accept( weather[city.id] )
        }
        .disposed(by: disposeBag)
    }
    

}
