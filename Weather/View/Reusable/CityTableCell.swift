//
//  MasterTableCell.swift
//  Weather
//
//  Created by 1234 on 22.11.2020.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CityTableCell: UITableViewCell, ReusableProtocol {
    
    // MARK: - Dependency
    private var viewModel: CityTableCellViewModel!
    
    // MARK: - Outlet
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
        
    // MARK: - Variables
    static let reusebleId = String(describing: CityTableCell.self)
    static let nib = UINib(nibName: String(describing: CityTableCell.self), bundle: nil)
    private let disposeBag = DisposeBag()
    
    // MARK: - Functions
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }    
    
    override func prepareForReuse() {
        
        cityNameLabel.text = "—"
        conditionLabel.text = "—"
        temperatureLabel.text = "—"
    }
    
    public func setViewModel(viewModel: CityTableCellViewModel) -> Void {
        
        self.viewModel = viewModel
        prepareForReuse()
        subscribe()
    }
    
    private func subscribe() {
        
        viewModel.name.drive { [weak self] (name) in
            self?.cityNameLabel?.text = name
        }
        .disposed(by: disposeBag)
        
        viewModel.weather.drive { [weak self] (weather) in
            self?.conditionLabel?.text = weather?.fact.condition ?? ""
            if (weather?.fact.temp != nil) {
                self?.temperatureLabel?.text = "\(weather?.fact.temp ?? 0) °C"
            }
        }
        .disposed(by: disposeBag)
    }
}
