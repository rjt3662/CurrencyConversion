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
    private var exchangeRates = [ExchangeRate]()
    private var dataRefreshTimer: Timer?
    var dataRefreshedCompletion: ((_ result: Result<[ExchangeRate], APIError>)->Void)?
    
    /// WIl calculate rates based on selected currency for amount given.
    func getExchangeRates(for amount: Double) -> [ExchangeRate] {
        var tempRates = exchangeRates
        var selectedCurrencyRate: ExchangeRate? = nil
        for (index, singleRate) in tempRates.enumerated() {
            if singleRate.code == self.selectedCurrency?.code ?? "" {
                selectedCurrencyRate = singleRate
                tempRates.remove(at: index)
            }
        }
        if let selectedRate = selectedCurrencyRate {
            for (index, _) in tempRates.enumerated() {
                let rate = tempRates[index].rate
                let convertedRate = selectedRate.code == CurrencyCode.dollar.rawValue ? rate * selectedRate.rate : rate / selectedRate.rate
                tempRates[index].rate = (convertedRate * amount)
            }
        }
        tempRates.sort(by: { $0.code < $1.code })
        return tempRates
    }
    
    /// WIll fetch conversion rates for USD as base currency.
    /// Cannot fetch currency rates based on year or based on any other base currency other than USD as these both APIs are not available in FREE plan.
    func fetchConversionRates(completion: @escaping ((_ result: Result<[ExchangeRate], APIError>)->Void)) {
        if isLastFetchedPassed30() {
            let localRates = CurrencyExchangeRateHandler.handler.fetchExchangeRates()
            if !localRates.isEmpty {
                self.exchangeRates = localRates
                completion(.success(localRates))
                self.setupDataRefreshTimer()
                return
            }
        }
        fetchRates(completion: completion)
    }
    
    private func fetchRates(completion: @escaping ((_ result: Result<[ExchangeRate], APIError>)->Void)) {
        APIClient.performRequest(route: APIRouter.live) { [weak self] (result: Result<ConversionResponse, APIError>) in
            guard let self = self else { return }
            switch result {
            case .success(let responseData):
                if let error = responseData.error {
                    completion(.failure(error))
                } else {
                    let rates = responseData.exchangeRates ?? []
                    self.exchangeRates = rates
                    UserDefaults.standard.lastFetchedDateTime = Date().getDateTimeString()
                    completion(.success(rates))
                    CurrencyExchangeRateHandler.handler.deleteAllRates()
                    CurrencyExchangeRateHandler.handler.saveExchangeRates(rates: rates)
                    self.setupDataRefreshTimer()
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func setupDataRefreshTimer() {
        if dataRefreshTimer != nil {
            return
        }
        dataRefreshTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkDataLastFetched), userInfo: nil, repeats: true)
        dataRefreshTimer?.fire()
        RunLoop.main.add(dataRefreshTimer!, forMode: .default)
    }
    
    @objc private func checkDataLastFetched(_ timer: Timer) {
        if isLastFetchedPassed30() {
            fetchRates { [weak self] (result) in
                guard let self = self else { return }
                self.dataRefreshedCompletion?(result)
            }
        }
    }
    
    /// WIll check if the data was fetched more than 30 minutes ago or not.
    private func isLastFetchedPassed30() -> Bool {
        if !UserDefaults.standard.lastFetchedDateTime.isEmpty {
            let lastFetchedDate = UserDefaults.standard.lastFetchedDateTime.getDate()
            let timeDifference = (Calendar.current.dateComponents([.minute], from: lastFetchedDate, to: Date()).minute?.magnitude ?? 0)
            return timeDifference >= 30
        }
        return false
    }
    
}
