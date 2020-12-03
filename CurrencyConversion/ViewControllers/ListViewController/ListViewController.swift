//
//  ListViewController.swift
//  CurrencyConversion
//
//  Created by Rajat Mishra on 03/12/20.
//

import UIKit

class ListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var currencyListTableView: UITableView!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    // MARK: - View Load Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyListTableView.register(ListTableCell.getNib(), forCellReuseIdentifier: ListTableCell.identifier)
        handleEvents()
    }
    
    // MARK: - Other Methods
    private func handleEvents() {
        
    }
    
    // MARK: - Handle Button Actions
    @IBAction func didTapCloseBarButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
