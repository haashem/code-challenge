//
//  ExchangeRateAPIEndToEndTests.swift
//  ExchangeRateAPIEndToEndTests
//
//  Created by Hashem Aboonajmi on 1/2/21.
//

import XCTest
import ExchangeRateFeature
import Networking
import ExchangeRateAPI

class ExchangeRateAPIEndToEndTests: XCTestCase {

    func test_endToEndTestServerGetExchangeRates_matchesFixedTestAccountData() {
        
        switch getLatestExchangeRates() {
        case let .success(exchangeRates):
            let rates = exchangeRates.rates
            XCTAssertEqual(rates.count, 164, "Expected 164 currency rate in from Fixer.io API")
            XCTAssertEqual(rates[0], expectedCurrecyRate(at: 0))
            XCTAssertEqual(rates[1], expectedCurrecyRate(at: 1))
            XCTAssertEqual(rates[2], expectedCurrecyRate(at: 2))
            XCTAssertEqual(rates[3], expectedCurrecyRate(at: 3))
            XCTAssertEqual(rates[4], expectedCurrecyRate(at: 4))
            XCTAssertEqual(rates[5], expectedCurrecyRate(at: 5))
            
        case let .failure(error):
            XCTFail("Expected successful exchnage rates result got \(error) instead")
        
        default:
            XCTFail("Expected successful exchnage rates result got no result instead")
            
        }
    }
    
    // MARK: - Helpers
    
    private func getLatestExchangeRates(file: StaticString = #file, line: UInt = #line) -> FixerExchangeRateLoader.Result? {
        
        let url = URL(string: "http://data.fixer.io/2013-12-24?access_key=537cc99b954a0e53d1c6e5f9fbbb04b4")!
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let loader = FixerExchangeRateLoader(url: url, client: client)
        
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line:  line)
        
        let exp = expectation(description: "wait for load completion")
        var receivedResult: FixerExchangeRateLoader.Result?
        // current API plan doesnt support providing base currency
        loader.latestExchangeRates(baseCurrency: "") { result in
            receivedResult = result
            exp.fulfill()
        }

        wait(for: [exp], timeout: 10.0)
        
        return receivedResult
    }
    
    private func expectedCurrecyRate(at index: Int) -> CurrencyRate {
        return CurrencyRate(symbol: symbol(at: index), rate: rate(at: index))
    }
    
    private func symbol(at index: Int) -> String {
        return
            ["AED",
             "AFN",
             "ALL",
             "AMD",
             "ANG",
             "AOA"][index]
    }
    
    private func rate(at index: Int) -> Double {
        return [5.023852,
                77.682521,
                139.568499,
                559.307478,
                2.446924,
                133.490067,][index]
    }
    
}
