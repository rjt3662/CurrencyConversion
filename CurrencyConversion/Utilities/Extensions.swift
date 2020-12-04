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

enum SegueIdentifiers {
    static let ShowListVC = "ShowListVC"
}
