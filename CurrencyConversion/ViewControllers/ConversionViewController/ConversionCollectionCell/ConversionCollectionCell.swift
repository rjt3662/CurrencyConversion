//
//  ConversionCollectionCell.swift
//  CurrencyConversion
//
//  Created by Rajat Mishra on 04/12/20.
//

import UIKit

class ConversionCollectionCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var codeContainerView: UIView!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    // MARK: - Properties
    static var identifier: String {
        return String(describing: self)
    }
    
    static func getNib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    // MARK: - Methods
    func configure(with exchangeRate: ExchangeRate) {
        codeLabel.text = exchangeRate.code
        rateLabel.text = "\(exchangeRate.rate)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyCodeContainerCorner()
    }
    
    private func applyCodeContainerCorner() {
        if codeContainerView != nil {
            codeContainerView.layer.cornerRadius = codeContainerView.frame.size.height/2
        }
    }
}
