//
//  ListViewController.swift
//  CurrencyConversion
//
//  Created by Rajat Mishra on 03/12/20.
//

import UIKit

protocol ListViewDelegate: AnyObject {
    func didSelect(currency: Currency, viewController: ListViewController)
}

class ListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var currencyListTableView: UITableView!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    // MARK: - Properties
    private var viewModel: ListViewModel!
    private var currencies = [Currency]()
    weak var delegate: ListViewDelegate?
    
    // MARK: - Controls
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.automaticallyShowsCancelButton = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.barTintColor = UIColor.accentColor
        searchController.searchBar.isTranslucent = false
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    private lazy var tableRefreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(tableRefreshControlStateChanged(_:)), for: .valueChanged)
        control.tintColor = .white
        return control
    }()
    
    // MARK: - View Load Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        currencyListTableView.refreshControl = tableRefreshControl
        navigationItem.searchController = searchController
        currencyListTableView.register(ListTableCell.getNib(), forCellReuseIdentifier: ListTableCell.identifier)
        viewModel = ListViewModel()
        fetchCurrencies()
    }
    
    // MARK: - Other Methods
    private func setupAppearance() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor.accentColor
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)
        ]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
    }
    
    private func fetchCurrencies(isPullToRefresh: Bool = false) {
        if !isPullToRefresh {
            loadingIndicatorView.startAnimating()
        }
        errorMessageLabel.text = ""
        viewModel.fetchCurrencies { [weak self] (result) in
            guard let self = self else { return }
            self.loadingIndicatorView.stopAnimating()
            self.tableRefreshControl.endRefreshing()
            switch result {
            case .success(let currencies):
                self.currencies = currencies
                self.currencyListTableView.reloadSections(IndexSet([0]), with: .automatic)
            case .failure(let error):
                self.errorMessageLabel.text = error.info
            }
        }
    }
    
    // MARK: - Handle Button Actions
    @IBAction func didTapCloseBarButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tableRefreshControlStateChanged(_ control: UIRefreshControl) {
        fetchCurrencies(isPullToRefresh: true)
    }
    
    func dismissSelf(completion: (() -> Void)?) {
        searchController.isActive = false
        dismiss(animated: true, completion: completion)
    }
    
}

extension ListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let result = viewModel.searchCurrency(by: searchController.searchBar.text ?? "")
        switch result {
        case .success(let currencies):
            self.errorMessageLabel.text = ""
            self.currencies = currencies
        case .failure(let error as NSError):
            self.currencies = []
            self.errorMessageLabel.text = error.domain
        }
        self.currencyListTableView.reloadSections(IndexSet([0]), with: .automatic)
    }
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let listCell = tableView.dequeueReusableCell(withIdentifier: ListTableCell.identifier) as? ListTableCell else {
            fatalError()
        }
        listCell.textLabel?.text = currencies[indexPath.row].name
        listCell.detailTextLabel?.text = currencies[indexPath.row].code
        return listCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(currency: currencies[indexPath.row], viewController: self)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}
