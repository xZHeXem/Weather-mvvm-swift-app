//
//  DetailsViewController.swift
//  Weather
//
//  Created by 1234 on 22.11.2020.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class DetailsViewController: UICollectionViewController {
    // MARK: - Dependency
    public var viewModel: DetailsViewModel?
    
    // MARK: - Variables
    private let disposeBag = DisposeBag()
    private let refreshView = UIRefreshControl()
    
    // MARK: - Functions
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        registerNibs()
        subscribe()
        configureRefresher()
    }    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if (viewModel?.forecastsCount() == 0) {
            
            viewModel?.fetchWeather()
        }
    }
    
    private func configureRefresher() {
        
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshView
        } else {
            collectionView.addSubview(refreshView)
        }
        
        // Configure Refresh Control
        refreshView.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    private func registerNibs() {
        
        collectionView.register(DetailCollectionCell.nib, forCellWithReuseIdentifier: DetailCollectionCell.reusebleId)
    }
    
    private func subscribe() {
        
        viewModel?.isLoading.drive { [weak self] (isLoading) in
            
            if (isLoading && self?.refreshView.isRefreshing ?? false) {
                self?.refreshView.beginRefreshing()
            } else {
                self?.refreshView.endRefreshing()
            }
        }
        .disposed(by: disposeBag)
        
        viewModel?.weather.drive { [weak self] _ in
            
            self?.collectionView.reloadData()
        }
        .disposed(by: disposeBag)
        
        viewModel?.name.drive { [weak self] (name) in
            self?.title = name
        }
        .disposed(by: disposeBag)
    }
    
    // MARK: - Callbacks
    @objc private func refreshData(_ sender: Any) {
        
        viewModel?.fetchWeather()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let insets: CGFloat = (flowLayout?.minimumInteritemSpacing ?? 0.0) + (flowLayout?.sectionInset.left ?? 0.0) + (flowLayout?.sectionInset.right ?? 0.0)
        let width: CGFloat = (collectionView.frame.size.width - insets) / 2.0
        return CGSize(width: width, height: width)
    }
}

// MARK: - UICollectionViewDelegate
extension DetailsViewController {
    
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        
        return viewModel?.forecastsCount() ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionCell.reusebleId, for: indexPath) as! DetailCollectionCell
        if let viewModel = viewModel?.viewModelForDetailsCell(at: indexPath.row) {
            cell.setViewModel(viewModel: viewModel)
        }
        return cell
    }
}
