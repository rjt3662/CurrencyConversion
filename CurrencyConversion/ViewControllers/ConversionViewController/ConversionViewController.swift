//
//  ConversionViewController.swift
//  CurrencyConversion
//
//  Created by Rajat Mishra on 03/12/20.
//

import UIKit

class ConversionViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var exchangeRatesCollectionView: UICollectionView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var selectedCurrencyNameCodeLabel: UILabel!
    @IBOutlet weak var noCurrencySelectedStackView: UIStackView!
    @IBOutlet weak var loadinIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var selectCurrencyButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    // MARK: - Properties
    private var viewModel: ConversionViewModel!
    private var exchangeRates = [ExchangeRate]()
    
    // MARK: - View Load Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        exchangeRatesCollectionView.register(ConversionCollectionCell.getNib(), forCellWithReuseIdentifier: ConversionCollectionCell.identifier)
        viewModel = ConversionViewModel()
        handleDataRefresh()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navController = segue.destination as? UINavigationController, let listViewController = navController.viewControllers.first as? ListViewController {
            listViewController.delegate = self
        }
    }
    
    // MARK: - Handle Actions
    @IBAction func didTapSelectCountryBarButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: SegueIdentifiers.ShowListVC, sender: nil)
    }
    
    @IBAction func didTapRetryButton(_ sender: UIButton) {
        self.fetchCurrencyConversion()
    }
    
    @IBAction func amountTextFieldEditingChanged(_ sender: UITextField) {
        self.exchangeRates = viewModel.getExchangeRates(for: Double(sender.text ?? "") ?? 1.0)
        self.exchangeRatesCollectionView.reloadData()
    }
    
    // MARK: - Other Methods
    private func updateUI(dataState: DataState) {
        self.loadinIndicatorView.stopAnimating()
        self.retryButton.isHidden = true
        switch dataState {
        case .loading:
            loadinIndicatorView.startAnimating()
            self.noCurrencySelectedStackView.isHidden = true
        case .empty:
            self.containerStackView.isHidden = true
            self.exchangeRatesCollectionView.isHidden = true
            self.noCurrencySelectedStackView.isHidden = false
        case .error:
            self.retryButton.isHidden = false
            self.containerStackView.isHidden = true
            self.exchangeRatesCollectionView.isHidden = true
            self.noCurrencySelectedStackView.isHidden = false
        case .dataPresent:
            self.containerStackView.isHidden = false
            self.exchangeRatesCollectionView.isHidden = false
            self.noCurrencySelectedStackView.isHidden = true
        }
        
        
        if let currency = viewModel.selectedCurrency {
            self.selectedCurrencyNameCodeLabel.text = "\(currency.code) - \(currency.name)"
        }
    }
    
    fileprivate func fetchCurrencyConversion() {
        updateUI(dataState: .loading)
        viewModel.fetchConversionRates { [weak self] (result) in
            guard let self = self else { return }
            self.handleResult(result)
        }
    }
    
    fileprivate func handleDataRefresh() {
        viewModel.dataRefreshedCompletion = { [weak self] result in
            self?.handleResult(result)
        }
    }
    
    fileprivate func handleResult(_ result: Result<[ExchangeRate], APIError>) {
        switch result {
        case .success(_):
            self.exchangeRates = self.viewModel.getExchangeRates(for: Double(self.amountTextField.text ?? "") ?? 1.0)
            self.exchangeRatesCollectionView.reloadData()
            self.updateUI(dataState: .dataPresent)
        case .failure(let error):
            self.errorMessageLabel.text = error.info
            self.updateUI(dataState: .error)
        }
        
    }
    
}

extension ConversionViewController: ListViewDelegate {
    
    func didSelect(currency: Currency, viewController: ListViewController) {
        viewModel.selectedCurrency = currency
        viewController.dismissSelf { [weak self] in
            guard let self = self else { return }
            self.fetchCurrencyConversion()
        }
    }
    
}

extension ConversionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exchangeRates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let conversionCell = collectionView.dequeueReusableCell(withReuseIdentifier: ConversionCollectionCell.identifier, for: indexPath) as? ConversionCollectionCell else {
            fatalError()
        }
        conversionCell.configure(with: exchangeRates[indexPath.row])
        conversionCell.layoutIfNeeded()
        return conversionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width / 3) - 20
        return CGSize(width: width, height: width*1.2)
    }
    
}
