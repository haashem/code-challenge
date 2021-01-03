//
//  ExchangeRateAPITests.swift
//  ExchangeRateAPITests
//
//  Created by Hashem Aboonajmi on 1/1/21.
//

import XCTest
import ExchangeRateAPI
import ExchangeRateFeature

class ExchangeRateAPITests: XCTestCase {

    func test_init_doesntRequestURL() {
        let client = HTTPClientSpy()
        _ = makeSUT()
        
        XCTAssertTrue(client.messages.isEmpty)
    }
    
    func test_loadTwice_requestDataFromURLTwice() {
        let baseCurrency = "anySymbol"
        let baseURLstring = "https://example.com/"
        let baseURL = URL(string: baseURLstring)!
        let expectedURL = URL(string: baseURLstring + "?base=\(baseCurrency)")
        let (sut, client) = makeSUT(baseURL: baseURL)
        
        sut.latestExchangeRates(baseCurrency: baseCurrency) {_ in }
        sut.latestExchangeRates(baseCurrency: baseCurrency) {_ in }
        
        XCTAssertEqual(client.requestedURLs, [expectedURL, expectedURL])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        let givenError = NSError(domain: "test", code: 0, userInfo: nil)
        
        expect(sut, toCompleteWithResult:
            failure(.connectivity), when: {
            client.complete(with: givenError)
        })
    }
    
    func test_load_deliversErrorOnJSONErrorResponse() {
        
        let (sut, client) = makeSUT()
       
        expect(sut, toCompleteWithResult:
                failure(.unauthorized), when: {
                    let json = makeFailureJSON(code: 101)
            client.complete(withStatusCode: 200, data: json, at: 0)
        })
        
        expect(sut, toCompleteWithResult:
                failure(.maximumAllowanceReached), when: {
                    let json = makeFailureJSON(code: 104)
            client.complete(withStatusCode: 401, data: json, at: 1)
        })
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { (arg) in
            
            let (index, code) = arg
            expect(sut, toCompleteWithResult:
                failure(.invalidData), when: {
                    let json = makeFailureJSON(code: code)
                client.complete(withStatusCode: code, data: json, at: index + 2)
            })
        }
    }

    func test_load_when200HTTPResponseWithInvalidData_deliversError() {
        // given
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithResult:
            failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_whenValidJSONdata_callCompletionWithExchangeRates() {
        // given
        let (sut, client) = makeSUT()

        let exchangeRate1 = makeItem(symbol: "AED", rate: 1.2)
        let exchangeRate2 = makeItem(symbol: "CMC", rate: 2.4)
        let exchangeRate3 = makeItem(symbol: "ZFD", rate: 2.1)

        let itemsJSON = makeItemJSON(baseCurrecny: "USD", [exchangeRate1.json, exchangeRate2.json, exchangeRate3.json])
        
        expect(sut, toCompleteWithResult: .success(ExchangeRates(baseCurrency: "USD", rates: [exchangeRate1.model, exchangeRate2.model, exchangeRate3.model])), when: {
            client.complete(withStatusCode: 200, data: itemsJSON)
        })
    }
    
    func test_load_doesNotDeliverResultAfterSUTinstanceHasBeenDeallocated() {
        let url = URL(string: "http://example.com")!
        let client = HTTPClientSpy()
        var sut: FixerExchangeRateLoader? = FixerExchangeRateLoader(url: url, client: client)
        let baseCurrency = "anySymbol"
        // when
        var capturedResults = [FixerExchangeRateLoader.Result]()
        
        sut?.latestExchangeRates(baseCurrency: baseCurrency) {
            capturedResults.append($0)
        }
        sut = nil
        client.complete(withStatusCode: 200, data: makeItemJSON(baseCurrecny: baseCurrency, []))
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: Helpers
    
    private func makeItem(symbol: String, rate: Double)  -> (model: CurrencyRate, json: [String: Any]){
        return (CurrencyRate(symbol: symbol, rate: rate), [symbol: rate])
    }
    
    private func makeSUT(baseURL url: URL = URL(string: "https://example.com")!) -> (FixerExchangeRateLoader, HTTPClientSpy) {
        
        let client = HTTPClientSpy()
        
        let sut = FixerExchangeRateLoader(url: url, client: client)
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(client)
        return (sut, client)
    }
    
    private func expect(_ sut: FixerExchangeRateLoader, toCompleteWithResult expectedResult: FixerExchangeRateLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "wait for load completion")
        sut.latestExchangeRates(baseCurrency: "") { receivedResult in
            
            switch (receivedResult, expectedResult) {
                case let (.success(receivedItems), .success(expectedItems)):
                    XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                case let (.failure(receivedError as FixerExchangeRateLoader.Error), .failure(expectedError as FixerExchangeRateLoader.Error)):
                    XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                default:
                    XCTFail("Expected \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1)
    }
    
    private func failure(_ error: FixerExchangeRateLoader.Error) -> FixerExchangeRateLoader.Result {
        return .failure(error)
    }
    
    private func makeItemJSON(baseCurrecny: String, _ items: [[String: Any]]) -> Data {
        let json: [String: Any] = [
            "success":true,
            "base":baseCurrecny,
            "rates": items.reduce(into: [:], { (dic, item) in
                dic[item.keys.first!] = item.values.first!
            })]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func makeFailureJSON(code: Int) -> Data {
        let json: [String: Any] = ["success":false,
            "error": [
                "code": code,
                "info": "any error message"]]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
}
