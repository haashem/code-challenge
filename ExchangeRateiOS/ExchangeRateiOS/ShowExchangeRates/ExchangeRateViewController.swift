//
//  ExchangeRateViewController.swift
//  ExchangeRateiOS
//
//  Created by Hashem Aboonajmi on 1/2/21.
//

import UIKit
import ExchangeRateFeature

public class ExchangeRateViewController: UIViewController {
    
    public var exchangeRateLoader: ExchangeRateLoader?
    private var tableModel = [CurrencyRate]()
    
    @IBOutlet private(set) public var activityInidcator: UIActivityIndicatorView!
    @IBOutlet private(set) public var tableView: UITableView!
    @IBOutlet private(set) public var baseCurrencyButton: UIButton! {
        didSet {
            baseCurrencyButton.backgroundColor = UIColor.white
        }
    }
    
    public var onCurrencyRateSelection: ((_ baseCurrency: String, _ rate: CurrencyRate) -> Void)?
    public var baseCurrency = "EUR"
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
   
    private func load() {
        activityInidcator.startAnimating()
        // Current API plan doesnt support base currency
        exchangeRateLoader?.latestExchangeRates(baseCurrency: "", completion: { [weak self] result in
            guard let self = self else { return }
            if let exchangeRates = try? result.get() {
                self.tableModel = exchangeRates.rates
                self.tableView.reloadData()
            }
            self.activityInidcator.stopAnimating()
        })
    }
}

extension ExchangeRateViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CurrencyRateCell.self)) as! CurrencyRateCell
        
        let currencyRate = tableModel[indexPath.row]
        cell.flag.image = UIImage(named: currencyRate.symbol.lowercased(), in: Bundle(for: Self.self), compatibleWith: nil)
        cell.symbolLabel.text = currencyRate.symbol
        cell.rateLabel.text = "\(currencyRate.rate)"
        
        return cell
    }
}

extension ExchangeRateViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onCurrencyRateSelection?(baseCurrency, tableModel[indexPath.row])
    }
}


