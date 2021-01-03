//
//  CurrencyRate.swift
//  CurrencyConvertorFeature
//
//  Created by Hashem Aboonajmi on 1/1/21.
//

import Foundation

public struct ExchangeRates: Equatable {
    public let baseCurrency: String
    public let rates: [CurrencyRate]
    public init(baseCurrency: String, rates: [CurrencyRate]) {
        self.baseCurrency = baseCurrency
        self.rates = rates
    }
}

public struct CurrencyRate: Equatable {
    public let symbol: String
    public let rate: Double
    
    public init(symbol: String, rate: Double) {
        self.symbol = symbol
        self.rate = rate
    }
}
