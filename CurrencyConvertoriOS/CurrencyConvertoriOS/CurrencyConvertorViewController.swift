//
//  CurrencyConvertorViewController.swift
//  CurrencyConvertoriOS
//
//  Created by Hashem Aboonajmi on 1/3/21.
//

import UIKit
import CurrencyConvertorFeature

public class CurrencyConvertorViewController: UIViewController {
    
    @IBOutlet private(set) public var baseSymboleLabel: UILabel!
    @IBOutlet private(set) public var amountField: UITextField!
    
    @IBOutlet private(set) public var targetSymboleLabel: UILabel!
    @IBOutlet private(set) public var targetSymboleRateLabel: UILabel!
    public var convertor: CurrencyConvertor?
    public var convertorInfo: ConvertorInfo?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        amountField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func setupView() {
        
        amountField.becomeFirstResponder()
      
        guard let convertorInfo = convertorInfo else {
            return
        }
        amountField.placeholder = "1.0"
        baseSymboleLabel.text = convertorInfo.baseSymbol
        targetSymboleLabel.text = convertorInfo.targetSymbol
        targetSymboleRateLabel.text = "\(convertorInfo.targetSymboleRate)"
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let convertorInfo = convertorInfo else {
            return
        }
        let amount: Double
        if let textFieldText = textField.text, textFieldText.isEmpty == false {
            amount = Double(textFieldText) ?? 1.0
        } else {
            amount = 1.0
        }
        convertor?.convert(amount: amount, from: convertorInfo.baseSymbol, to: convertorInfo.targetSymbol, completion: { result in
            let convertedValue = try! result.get()
            self.targetSymboleRateLabel.text = "\(convertedValue)"
        })
        
    }
}
