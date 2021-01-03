//
//  CurrencyConvertorTests.swift
//  CurrencyConvertorTests
//
//  Created by Hashem Aboonajmi on 1/3/21.
//

import XCTest
import OfflineCurrencyConvertor

class OfflineCurrencyConvertorTests: XCTestCase {

    func test_convert_convertCurrency() {
        let targetSymbolRate = 0.6
        let sut = makeSUT(targetSymbolRate: targetSymbolRate)
        let amountToConvert = 10.0
        let baseSymbole = "USD"
        let targetSymbole = "GBP"
        
        let exp = expectation(description: "wait for convertion completion")
        var convertedResult: Double?
        
        sut.convert(amount: amountToConvert, from: baseSymbole, to: targetSymbole) { result in
            convertedResult = try! result.get()
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        
        let expectedResult = 6.0
        XCTAssertEqual(convertedResult, expectedResult, "Expected \(expectedResult) got \(String(describing: convertedResult)) instead")
    }
    
    // MARK: - Helpers
    
    func makeSUT(targetSymbolRate: Double) -> OfflineCurrencyConvertor {
        return OfflineCurrencyConvertor(targetCurrencyRate: targetSymbolRate)
    }

}
