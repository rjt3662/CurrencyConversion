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
    
    // MARK: - Properties
    private var viewModel: ConversionViewModel!
    private var exchangeRates = [ExchangeRate]()
    
    // MARK: - View Load Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        exchangeRatesCollectionView.register(ConversionCollectionCell.getNib(), forCellWithReuseIdentifier: ConversionCollectionCell.identifier)
        viewModel = ConversionViewModel()
        viewModel.fetchConversionRates { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let rates):
                self.exchangeRates = rates
                self.exchangeRatesCollectionView.reloadSections(IndexSet([0]))
            case .failure(let error):
                print(error)
            }
        }
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
    
    @IBAction func didTapChangeCountryBarButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: SegueIdentifiers.ShowListVC, sender: nil)
    }
    
    // MARK: - Other Methods
    private func updateUI() {
        self.containerStackView.isHidden = viewModel.selectedCurrency == nil
    }
    
}

extension ConversionViewController: ListViewDelegate {
    
    func didSelect(currency: Currency, viewController: ListViewController) {
        viewModel.selectedCurrency = currency
        viewController.dismiss(animated: true, completion: nil)
        updateUI()
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
