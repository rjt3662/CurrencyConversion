//
//  Extensions.swift
//  CurrencyConversion
//
//  Created by Rajat Mishra on 03/12/20.
//

import UIKit

typealias StringString = [String: String]
typealias StringDouble = [String: Double]

extension UIColor {
    
    @nonobjc class var accentColor: UIColor {
        return UIColor(named: "AccentColor")!
    }
    
}

private let keyLastFetchedTimestamp = "last_fetched_timestamp"
extension UserDefaults {
    
    ///Last timestamp when API was called to fetch currency exchange rates.
    var lastFetchedDateTime: String {
        get {
            return string(forKey: keyLastFetchedTimestamp) ?? ""
        }
        set {
            set(newValue, forKey: keyLastFetchedTimestamp)
        }
    }
    
}

enum SegueIdentifiers {
    static let ShowListVC = "ShowListVC"
}
let dateTimeFormat = "dd-MM-yyyy HH:mm:ss"
extension Date {
    
    func getDateTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateTimeFormat
        return dateFormatter.string(from: self)
    }
    
}

extension String {
    
    func getDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateTimeFormat
        if let date = dateFormatter.date(from: self) {
            return date
        }
        fatalError()
    }
    
}

extension Double {
    
    func toDecimal(places: Int = 4) -> Double {
        let divisor = pow(10.0, Double(places))
        var roundVal = self * divisor
        roundVal = roundVal.rounded()
        return roundVal / divisor
    }
    
}

enum CurrencyCode: String {
    case dollar = "USD"
}

enum DataState {
    case loading, empty, error, dataPresent
}
