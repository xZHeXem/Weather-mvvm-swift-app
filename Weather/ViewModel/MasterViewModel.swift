//
//  MasterViewModel.swift
//  Weather
//
//  Created by 1234 on 22.11.2020.
//

import Foundation
import RxSwift
import RxCocoa

class MasterViewModel {
    
    // MARK: - Dependency
    private var cityRepository: CityRepositoryProtocol
    private var weatherRepository: WeatherRepositoryProtocol
    
    // MARK: - Variables
    private let disposeBag = DisposeBag()
    
    // MARK: - Relay
    private let _cities = BehaviorRelay<[CityModel]>(value: [])
    private let _filter = BehaviorRelay<String?>(value: nil)
    private let _filteredCities = BehaviorRelay<[CityModel]>(value: [])
    private let _isLoading = BehaviorRelay<Bool>(value: false)
    private let _error = BehaviorRelay<Error?>(value: nil)
    private let _weathers = BehaviorRelay<[Int: WeatherModel]>(value: [:])    
    
    // MARK: - Drivers
    public var isLoading: Driver<Bool> {
        
        return _isLoading.asDriver()
    }
    
    public var error: Driver<Error?> {
        
        return _error.asDriver()
    }
    
    public var cities: Driver<[CityModel]> {
        
        return _cities.asDriver()
    }
    
    public var filteredCities: Driver<[CityModel]> {
        
        return _filteredCities.asDriver()
    }
    
    private var weathers: Driver<Dictionary<Int, WeatherModel>> {
        
        return _weathers.asDriver()
    }
    
    public var citiesCount: Int {
        
        return _cities.value.count
    }
    
    public var filteredCitiesCount: Int {
        
        return _filteredCities.value.count
    }
    
    // MARK: - Functions
    init(cityRepository: CityRepositoryProtocol?, weatherRepository: WeatherRepositoryProtocol?) {
        self.cityRepository = cityRepository!
        self.weatherRepository = weatherRepository!
        
        fetchCities()
    }
    
    public func filterCities(filter: String?) {
        
        if (filter?.count ?? 0 == 0) {
            _filter.accept(nil)
            _filteredCities.accept(self._cities.value)
            return
        }
        
        _filter.accept(filter)
        
        _filteredCities.accept(self._cities.value.filter({ (city) -> Bool in
            city.name.contains { (_, value) -> Bool in
                return value.localizedCaseInsensitiveContains(filter!)
            }
        }))
    }
    
    public func fetchCities() {
        // clearing
        self._cities.accept([])
        self._isLoading.accept(true)
        self._error.accept(nil)

        cityRepository.getCities(completionHandler: { [weak self] (cities, error) in
            self?._cities.accept(cities)
            self?._isLoading.accept(false)
            self?._error.accept(error)
            
            self?.filterCities(filter: self?._filter.value)
            
            
            if (error != nil || self?._cities == nil) {
                self?._error.accept(error)
                return
            }
            
            self?.fetchWeather()
        })
    }
    
    private func fetchWeather() {
        _cities.value.forEach { city in
            weatherRepository.forecastShort(city: city) {[weak self] (weather, error) in
                
                if (error != nil || self?._weathers == nil) {
                    self?._error.accept(error)
                    return
                }
                
                var tmp = self?._weathers.value
                tmp?[city.id] = weather
                self?._weathers.accept(tmp!)
            }
        }
    }
    
    // MARK: - Provide ViewModel    
    public func viewModelForCity(at: Int) -> CityTableCellViewModel? {
        if (_filteredCities.value.indices.contains(at)) {
            let city =  _filteredCities.value[at]
            return CityTableCellViewModel(city: city, weather: weathers)
        } else {
            return nil
        }
    }
    
    public func viewModelForDetails(at: Int) -> DetailsViewModel? {
        if (_filteredCities.value.indices.contains(at)) {
            let city =  _filteredCities.value[at]
            return DetailsViewModel(city: city, weatherRepository: weatherRepository, weather: weathers)
        } else {
            return nil
        }
    }
}
