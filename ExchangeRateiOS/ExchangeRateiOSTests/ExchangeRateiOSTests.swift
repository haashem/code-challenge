//
//  ExchangeRateiOSTests.swift
//  ExchangeRateiOSTests
//
//  Created by Hashem Aboonajmi on 1/2/21.
//

import XCTest
import ExchangeRateAPI
import ExchangeRateFeature
import ExchangeRateiOS
import UIKit

class ExchangeRateiOSTests: XCTestCase {

    func test_init_doesnNotLoadExchangeRates() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.latestExchangeRatesFeedCallCount, 0, "Expected no loading requests before view is loaded")
    
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.latestExchangeRatesFeedCallCount, 1, "Expected a loading request once view is loaded")
    }
    
    func test_viewDidLoad_showsLoadingIndicator() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndictor, "Expected loading indicator once view is loaded")
        
        loader.completeExchangeRatesLoading(at: 0)
        XCTAssertTrue(sut.isLoadingIndictorHidden, "Expected no loading indicator once loading completes successfully")
    }
    
    func test_exchangeRateLoadCompletion_rendersSuccessfullyLoadedRates() {
        let baseCurrency = "EUR"
        let currencyRate0 = makeCurrencyRate(symbol: "AED", rate: 1.0)
        let currencyRate1 = makeCurrencyRate(symbol: "USD", rate: 1.1)
        let emptyExchangeRates = ExchangeRates(baseCurrency: "", rates: [])
        let exchangeRates = ExchangeRates(baseCurrency: baseCurrency, rates: [currencyRate0, currencyRate1])
        
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: emptyExchangeRates)
        
        loader.completeExchangeRatesLoading(with: exchangeRates, at: 0)
        assertThat(sut, isRendering: exchangeRates)
    }
    
    private func assertThat(_ sut: ExchangeRateViewController, isRendering exchangeRates: ExchangeRates, file: StaticString = #file, line: UInt = #line) {
        
        guard sut.numberOfRenderedCurrencyRates() == exchangeRates.rates.count else {
            return XCTFail("Expected \(exchangeRates.rates.count) currency rates, got \(sut.numberOfRenderedCurrencyRates()) instead.", file: file, line: line)
        }
        
        exchangeRates.rates.enumerated().forEach { index, currencyRate in
            assertThat(sut, hasViewConfiguredFor: currencyRate, at: index)
        }
    }
    
    private func assertThat(_ sut: ExchangeRateViewController, hasViewConfiguredFor currencyRate: CurrencyRate, at index: Int, file: StaticString = #file, line: UInt = #line) {
        let view = sut.currencyRateView(at: index)
        
        guard let cell = view as? CurrencyRateCell else {
            return XCTFail("Expected \(CurrencyRateCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }
        if let image = UIImage(named: currencyRate.symbol.lowercased()) {
            XCTAssertEqual(cell.flag.image, image, "Expected flag to be set for currency at index \(index)", file: file, line: line)
        }
        XCTAssertEqual(cell.symbolLabel.text, currencyRate.symbol, "Expected symbol text to be \(currencyRate.symbol) for currency rate at index \(index)", file: file, line: line)
        XCTAssertEqual(cell.rateLabel.text, "\(currencyRate.rate)", "Expected arte text to be \(currencyRate.rate) for currency rate at index \(index)", file: file, line: line)
    }
    
        
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: ExchangeRateViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: ExchangeRateViewController.self))
        let sut = storyboard.instantiateInitialViewController() as! ExchangeRateViewController
        
        sut.exchangeRateLoader = loader
        
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, loader)
    }
    
    private func makeCurrencyRate(symbol: String, rate: Double) -> CurrencyRate {
        return CurrencyRate(symbol: symbol, rate: rate)
    }
    
    class LoaderSpy: ExchangeRateLoader {
        
        private var exchangeRatesRequests = [(FixerExchangeRateLoader.Result) -> Void]()
        var latestExchangeRatesFeedCallCount: Int {
            return exchangeRatesRequests.count
        }
        
        func latestExchangeRates(baseCurrency: String, completion: @escaping (FixerExchangeRateLoader.Result) -> Void) {
            exchangeRatesRequests.append(completion)
        }
        
        func completeExchangeRatesLoading(with rates: ExchangeRates = ExchangeRates(baseCurrency: "", rates: []), at index: Int = 0) {
            exchangeRatesRequests[index](.success(rates))
        }
        
        func completeExchangeRatesLoadingWithError(at index: Int) {
            let error = NSError(domain: "an error", code: 0)
            exchangeRatesRequests[index](.failure(error))
        }
    }

}

private extension ExchangeRateViewController {
    
    var isShowingLoadingIndictor: Bool {
        return activityInidcator.isAnimating == true && activityInidcator.isHidden == false
    }
    
    var isLoadingIndictorHidden: Bool {
        return activityInidcator.isAnimating == false && activityInidcator.isHidden == true
    }
    
    func numberOfRenderedCurrencyRates() -> Int {
        return tableView.numberOfRows(inSection: 0)
    }
    
    func currencyRateView(at row: Int) -> UITableViewCell? {
        let dataSource = tableView.dataSource
        let index = IndexPath(row: row, section: 0)
        return dataSource?.tableView(tableView, cellForRowAt: index)
    }
    
    
}
