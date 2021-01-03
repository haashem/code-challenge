//
//  CurrencyConvertor.swift
//  CurrencyConvertor
//
//  Created by Hashem Aboonajmi on 1/3/21.
//

import Foundation
import CurrencyConvertorFeature

public class OfflineCurrencyConvertor: CurrencyConvertor {
    
    public typealias Result = CurrencyConvertor.Result
    
    private let targetCurrencyRate: Double
    public init(targetCurrencyRate: Double) {
        self.targetCurrencyRate = targetCurrencyRate
    }
    
    public func convert(amount: Double, from baseSymbole: String, to targetSymbol: String, completion: @escaping (Result) -> Void) {
        
        completion(.success(amount*targetCurrencyRate))
    }
    
    
}
