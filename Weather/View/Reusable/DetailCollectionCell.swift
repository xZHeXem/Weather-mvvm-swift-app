//
//  DetailCollectionCell.swift
//  Weather
//
//  Created by 1234 on 22.11.2020.
//

import UIKit
import RxSwift
import RxCocoa

class DetailCollectionCell: UICollectionViewCell, ReusableProtocol {
    // MARK: - Dependency
    private var viewModel: DetailCollectionCellViewModel?
    
    // MARK: - Outlet
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var condition: UILabel!
    
    // MARK: - Variables
    static let reusebleId = String(describing: DetailCollectionCell.self)
    static let nib = UINib(nibName: String(describing: DetailCollectionCell.self), bundle: nil)
    private let disposeBag = DisposeBag()
    
    // MARK: - Functions
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }
    
    private func subscribe() {
        
        viewModel?.forecast.drive { [weak self] (forecast) in            
            // TODO: fix it while localization
            self?.tempLabel?.text = "\(forecast!.parts["day"]?.temp_avg ?? forecast!.parts["day"]?.temp ?? 0) °C"
            self?.dayLabel.text = forecast?.date
            self?.condition?.text = forecast!.parts["day"]?.condition ?? ""
            
        }
        .disposed(by: disposeBag)
    }
    
    public func setViewModel(viewModel: DetailCollectionCellViewModel) -> Void {
        
        self.viewModel = viewModel
        subscribe()
    }
}
