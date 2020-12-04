//
//  ListViewModel.swift
//  CurrencyConversion
//
//  Created by Rajat Mishra on 03/12/20.
//

import Foundation
import Alamofire

class ListViewModel {
    
    // MARK: - Properties
    private var currencyListResponse: CurrencyListResponse? = nil
    
    func searchCurrency(by searchText: String) -> Result<[Currency], Error> {
        let allCurrencies = currencyListResponse?.currencies ?? []
        if searchText.isEmpty {
            return .success(allCurrencies)
        }
        let lowercasedSearchText = searchText.lowercased()
        let filteredCurrencies = allCurrencies.filter { (singleCurrency) -> Bool in
            return singleCurrency.code.lowercased().contains(lowercasedSearchText) || singleCurrency.name.lowercased().contains(lowercasedSearchText)
        }
        if filteredCurrencies.isEmpty {
            return .failure(NSError(domain: "No currency found.", code: -1, userInfo: [:]))
        } else {
            return .success(filteredCurrencies)
        }
    }
    
    func fetchCurrencies(completion: @escaping ((_ result: Result<[Currency], APIError>)->Void)) {
        APIClient.performRequest(route: APIRouter.currencyList) { [weak self] (result: Result<CurrencyListResponse, APIError>) in
            guard let self = self else { return }
            switch result {
            case .success(let responseData):
                if let error = responseData.error {
                    completion(.failure(error))
                } else {
                    self.currencyListResponse = responseData
                    completion(.success(responseData.currencies ?? []))
                }
                break
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
