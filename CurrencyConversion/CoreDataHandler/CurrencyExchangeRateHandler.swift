//
//  CurrencyExchangeRateHandler.swift
//  CurrencyConversion
//
//  Created by Rajat Mishra on 04/12/20.
//

import UIKit
import CoreData

class CurrencyExchangeRateHandler {
    
    static let handler = CurrencyExchangeRateHandler()
    private var viewContext: NSManagedObjectContext!
    private let entityName = "CurrencyExchangeRate"
    
    init() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            viewContext = appDelegate.persistentContainer.viewContext
        } else {
            fatalError()
        }
    }
    
    func saveExchangeRates(rates: [ExchangeRate]) {
        if let exchangeRateEntity = NSEntityDescription.entity(forEntityName: entityName, in: viewContext) {
            rates.forEach { (singleRate) in
                if let exchangeRateObject = NSManagedObject(entity: exchangeRateEntity, insertInto: viewContext) as? CurrencyExchangeRate {
                    exchangeRateObject.rate = singleRate.rate
                    exchangeRateObject.code = singleRate.code
                }
            }
            saveContext()
        } else {
            fatalError()
        }
    }
    
    func fetchExchangeRates() -> [ExchangeRate] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        var rates = [ExchangeRate]()
        do {
            let result = try viewContext.fetch(fetchRequest)
            if let contexts = result as? [CurrencyExchangeRate] {
                contexts.forEach { (singleExchangeRate) in
                    rates.append(ExchangeRate(code: singleExchangeRate.code ?? "", rate: singleExchangeRate.rate))
                }
            }
        } catch {
            print("Error fetching exchange rates from core data: \(error.localizedDescription)")
        }
        return rates
    }
    
    func deleteAllRates() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let result = try viewContext.fetch(fetchRequest)
            if let contexts = result as? [NSManagedObject] {
                contexts.forEach { (singleExchangeRate) in
                    self.viewContext.delete(singleExchangeRate)
                }
                saveContext()
            }
        } catch {
            print("Error fetching exchange rates from core data: \(error.localizedDescription)")
        }
    }
    
    private func saveContext() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.saveContext()
        } else {
            fatalError()
        }
    }
    
}
