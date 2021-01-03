//
//  CurrencyConvertor.swift
//  ExchangeRateFeature
//
//  Created by Hashem Aboonajmi on 1/3/21.
//

import Foundation

public protocol CurrencyConvertor {
    typealias Result = Swift.Result<Double, Error>
    func convert(amount: Double, from baseSymbole: String, to targetSymbol: String, completion: @escaping(Result) -> Void)
}
