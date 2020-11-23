//
//  DependencyConfigurator.swift
//  Weather
//
//  Created by 1234 on 22.11.2020.
//

import SwinjectStoryboard

extension SwinjectStoryboard {
    class func setup() {
        
        // MARK: - Protocols
        defaultContainer.register(NetworkProtocol.self) { _ in Network() }
        defaultContainer.register(CityRepositoryProtocol.self) { _ in CityRepository() }
        defaultContainer.register(WeatherRepositoryProtocol.self) { r in WeatherRepository(network: r.resolve(NetworkProtocol.self)) }
        
        // MARK: - StoryBoards
        defaultContainer.storyboardInitCompleted(MasterViewController.self) { r, c in
            c.viewModel = MasterViewModel(cityRepository: r.resolve(CityRepositoryProtocol.self), weatherRepository: r.resolve(WeatherRepositoryProtocol.self))
        }
        
        // unised
        defaultContainer.storyboardInitCompleted(DetailsViewController.self) { _, _ in }        
        defaultContainer.storyboardInitCompleted(SplitViewController.self) { _, _ in }
        defaultContainer.storyboardInitCompleted(UIViewController.self) { _, _ in }
        defaultContainer.storyboardInitCompleted(UINavigationController.self) { _, _ in }
        defaultContainer.storyboardInitCompleted(UICollectionViewController.self) { _, _ in }
    }
}
