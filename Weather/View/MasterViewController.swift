//
//  ViewController.swift
//  weather
//
//  Created by 1234 on 22.11.2020.
//

import UIKit
import RxSwift
import RxCocoa

class MasterViewController: UITableViewController {
    // MARK: - Dependency
    public var viewModel: MasterViewModel!
    
    // MARK: - Variables
    private let disposeBag = DisposeBag()
    private let refreshView = UIRefreshControl()
    private let segueAction = "showDetail"
    
    // MARK: - Functions
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        registerNibs()
        configureSearchController()
        configureRefresher()
        subscribe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.searchController?.isActive = false
    }
        
    private func registerNibs() {
        
        tableView.register(CityTableCell.nib, forCellReuseIdentifier: CityTableCell.reusebleId)
    }
    
    private func configureSearchController() {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
        self.modalPresentationStyle = .currentContext
    }
    
    private func configureRefresher() {
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshView
        } else {
            tableView.addSubview(refreshView)
        }
        
        // Configure Refresh Control
        refreshView.addTarget(self, action: #selector(refreshData), for: .valueChanged)
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
        
        viewModel.error.drive { (error) in
            if (error != nil) {
                print("error: \(error!.localizedDescription)")
            }
        }
        .disposed(by: disposeBag)
        
        viewModel.filteredCities.drive {[weak self] _ in
            self?.tableView.reloadData()
        }
        .disposed(by: disposeBag)
    }
    
    // MARK: - Callbacks
    @objc private func refreshData(_ sender: Any) {
        
        viewModel?.fetchCities()
    }
}

// MARK: - UISearchResultsUpdating
extension MasterViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filterCities(filter: searchController.searchBar.text)
    }
}

// MARK: - UITableViewDelegate
extension MasterViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueAction {
            if let navigator = segue.destination as? UINavigationController,
                let details = navigator.topViewController as? DetailsViewController,
                let path = tableView.indexPathForSelectedRow as NSIndexPath? {
                details.viewModel = viewModel.viewModelForDetails(at: path.row)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.filteredCitiesCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableCell.reusebleId, for: indexPath) as! CityTableCell
        
        if let viewModel = viewModel.viewModelForCity(at: indexPath.row) {
            cell.setViewModel(viewModel: viewModel)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: segueAction, sender: self)
    }
}
