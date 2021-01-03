//
//  CurrencyConvertor.swift
//  CurrencyConvertorFeature
//
//  Created by Hashem Aboonajmi on 1/1/21.
//

import Foundation

public protocol ExchangeRateLoader {
    typealias Result = Swift.Result<ExchangeRates, Error>
    func latestExchangeRates(baseCurrency: String, completion: @escaping(Result) -> Void)
}

