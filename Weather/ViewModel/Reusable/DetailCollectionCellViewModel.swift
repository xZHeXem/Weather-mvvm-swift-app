//
//  DetailCollectionCellViewModel.swift
//  Weather
//
//  Created by 1234 on 22.11.2020.
//

import Foundation
import RxSwift
import RxCocoa

class DetailCollectionCellViewModel {
    
    // MARK: - Dependency
    private var weatherRepository: WeatherRepositoryProtocol!
    
    // MARK: - Variables
    private let disposeBag = DisposeBag()
        
    // MARK: - Relay
    private let _forecast = BehaviorRelay<ForecastModel?>(value: nil)
    
    // MARK: - Drivers
    public var forecast: Driver<ForecastModel?> {
        
        return _forecast.asDriver()
    }
    
    // MARK: - Functions
    init(dayId: Int, weatherRepository: WeatherRepositoryProtocol?, weather: Driver<WeatherModel?>) {
        
        // TODO: Make weather request at init to refresh
        self.weatherRepository = weatherRepository!
        
        weather.drive { [weak self] (weather) in
            self?._forecast.accept(weather?.forecasts[dayId])
        }
        .disposed(by: disposeBag)
    }
}
