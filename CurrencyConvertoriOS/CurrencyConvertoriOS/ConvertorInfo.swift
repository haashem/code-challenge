//
//  ConvertorInfo.swift
//  CurrencyConvertoriOS
//
//  Created by Hashem Aboonajmi on 1/3/21.
//

import Foundation

public struct ConvertorInfo {
    public let baseSymbol: String
    public let targetSymbol: String
    public let targetSymboleRate: Double
    
    public init(baseSymbol: String, targetSymbol: String, targetSymboleRate: Double) {
        self.baseSymbol = baseSymbol
        self.targetSymbol = targetSymbol
        self.targetSymboleRate = targetSymboleRate
    }
}
