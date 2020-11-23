//
//  DetailViewModel.swift
//  Weather
//
//  Created by 1234 on 22.11.2020.
//

import Foundation


import Foundation
import RxSwift
import RxCocoa

class DetailsViewModel {
    
    // MARK: - Dependency
    private var weatherRepository: WeatherRepositoryProtocol!
    
    // MARK: - Variables
    fileprivate let locale = Locale.current.languageCode
    
    // MARK: - Relay
    private let _isLoading = BehaviorRelay<Bool>(value: false)
    private let _name = BehaviorRelay<String>(value: "")
    private let _error = BehaviorRelay<Error?>(value: nil)
    private let _weather = BehaviorRelay<WeatherModel?>(value: nil)
    private let _city = BehaviorRelay<CityModel?>(value: nil)
    private let disposeBag = DisposeBag()
    
    // MARK: - Drivers
    public var isLoading: Driver<Bool> {
        
        return _isLoading.asDriver()
    }
    
    public var error: Driver<Error?> {
        
        return _error.asDriver()
    }
    
    public var name: Driver<String> {
        
        return _name.asDriver()
    }
    
    public var weather: Driver<WeatherModel?> {
        
        return _weather.asDriver()
    }
        
    // MARK: - Functions
    init(city: CityModel, weatherRepository: WeatherRepositoryProtocol?, weather: Driver<Dictionary<Int, WeatherModel>>) {
        
        self.weatherRepository = weatherRepository!
        
        _city.accept(city)
        
        let cityName = city.getNameByLocale(locale: locale)
        _name.accept( cityName )
        
        weather.drive { [weak self] (w: Dictionary<Int, WeatherModel>) in
            self?._weather.accept(w[city.id])
        }
        .disposed(by: disposeBag)
    }
    
    public func fetchWeather() {
        
        guard let city = _city.value else { return }
        
        self._isLoading.accept(true)
        self._error.accept(nil)
        
        weatherRepository.forecastShort(city: city) {[weak self] (weather, error) in
            
            self?._isLoading.accept(false)

            if (error != nil || self?._weather == nil) {
                self?._error.accept(error)
                return
            }
            
            self?._weather.accept(weather)
        }
    }
    
    public func forecastsCount() -> Int {
        
        return _weather.value?.forecasts.count ?? 0
    }
    
    // MARK: - Provide ViewModel
    public func viewModelForDetailsCell(at: Int) -> DetailCollectionCellViewModel? {
        
        return DetailCollectionCellViewModel(dayId: at, weatherRepository: weatherRepository, weather: weather)
    }
}
