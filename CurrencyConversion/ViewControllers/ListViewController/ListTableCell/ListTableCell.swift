//
//  ListTableCell.swift
//  CurrencyConversion
//
//  Created by Rajat Mishra on 03/12/20.
//

import UIKit

class ListTableCell: UITableViewCell {
    
    // MARK: - Properties
    static var identifier: String {
        return String(describing: self)
    }
    
    static func getNib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
}
