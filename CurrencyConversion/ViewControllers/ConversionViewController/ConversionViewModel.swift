//
//  ConversionViewModel.swift
//  CurrencyConversion
//
//  Created by Rajat Mishra on 03/12/20.
//

import Foundation
import Alamofire

class ConversionViewModel {
    
    // MARK: - Properties
    var selectedCurrency: Currency?
    private var conversionResponse: ConversionResponse?
    
    /// WIll fetch conversion rates for USD as base currency.
    func fetchConversionRates(completion: @escaping ((_ result: Result<[ExchangeRate], APIError>)->Void)) {
        APIClient.performRequest(route: APIRouter.live) { [weak self] (result: Result<ConversionResponse, APIError>) in
            guard let self = self else { return }
            switch result {
            case .success(let responseData):
                self.conversionResponse = responseData
                if let error = responseData.error {
                    completion(.failure(error))
                } else {
                    completion(.success(responseData.exchangeRates ?? []))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
