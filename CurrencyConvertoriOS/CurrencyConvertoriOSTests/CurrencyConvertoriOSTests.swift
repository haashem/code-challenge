//
//  CurrencyConvertoriOSTests.swift
//  CurrencyConvertoriOSTests
//
//  Created by Hashem Aboonajmi on 1/3/21.
//

import XCTest
import CurrencyConvertoriOS
import OfflineCurrencyConvertor


class CurrencyConvertoriOSTests: XCTestCase {

    func test_navBarTitle_isConvertor() {
        let sut = makeSUT()
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, "Convertor")
    }
    
    func test_viewDidAppear_keyboardIsVisible() {
        let sut = makeSUT()
        // In order for a view/subview to become first responder, it must be part of a view hierarchy, meaning that its root view's window property must be set.
        let window = UIWindow()
        window.addSubview(sut.view)
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(sut.isKeyboardVisible)
    }
    
    func test_viewDidLoad_showInitialConversionInfo() {
        let convertorInfo = ConvertorInfo(baseSymbol: "USD", targetSymbol: "EUR", targetSymboleRate: 1.4)
        let sut = makeSUT(convertorInfo: convertorInfo)
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.amountField.placeholder, "1.0")
        XCTAssertEqual(sut.baseSymboleLabel.text, convertorInfo.baseSymbol)
        XCTAssertEqual(sut.targetSymboleRateLabel.text, "\(convertorInfo.targetSymboleRate)")
        XCTAssertEqual(sut.targetSymboleLabel.text, convertorInfo.targetSymbol)
    }
    
    func test_onEmptyField_converts1AmountToTargetCurrency() {
        let convertorInfo = ConvertorInfo(baseSymbol: "USD", targetSymbol: "EUR", targetSymboleRate: 1.4)
       
        let sut = makeSUT(convertorInfo: convertorInfo)
        sut.loadViewIfNeeded()
        
        sut.simulateUserChangedTextFieldValue(value: "")
        
        let expectedValue = 1.4
        XCTAssertEqual(sut.targetSymboleRateLabel.text, "\(expectedValue)")
    }
    
    func test_onTextFieldChange_withInvalidAmount_doesntConvert() {
        let convertorInfo = ConvertorInfo(baseSymbol: "USD", targetSymbol: "EUR", targetSymboleRate: 1.4)
       
        let sut = makeSUT(convertorInfo: convertorInfo)
        sut.loadViewIfNeeded()
        
        sut.simulateUserChangedTextFieldValue(value: "asd")
        
        let expectedValue = 1.4
        XCTAssertEqual(sut.targetSymboleRateLabel.text, "\(expectedValue)")
    }
    
    func test_OnTextFieldChange_convertsAmountToTargetCurrency() {
        let convertorInfo = ConvertorInfo(baseSymbol: "USD", targetSymbol: "EUR", targetSymboleRate: 1.4)
        let amountToConvert = 2.0
        let sut = makeSUT(convertorInfo: convertorInfo)
        sut.loadViewIfNeeded()
        
        sut.simulateUserChangedTextFieldValue(value: "\(amountToConvert)")
        
        let expectedValue = 2.8
        XCTAssertEqual(sut.targetSymboleRateLabel.text, "\(expectedValue)")
    }
    
    
    // MARK: - Helpers
    
    func makeSUT(convertorInfo: ConvertorInfo = ConvertorInfo(baseSymbol: "USD", targetSymbol: "GBD", targetSymboleRate: 0.6), file: StaticString = #file, line: UInt = #line) -> CurrencyConvertorViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: CurrencyConvertorViewController.self))
        let sut = storyboard.instantiateInitialViewController() as! CurrencyConvertorViewController
        let convertor = OfflineCurrencyConvertor(targetCurrencyRate: convertorInfo.targetSymboleRate)
        sut.convertor = convertor
        sut.convertorInfo = convertorInfo
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(convertor, file: file, line: line)
        return sut
        
    }
}

extension CurrencyConvertorViewController {
    
    var isKeyboardVisible: Bool {
        return amountField.isFirstResponder == true
    }
    
    func simulateUserChangedTextFieldValue(value: String) {
        amountField.text = value
        amountField.simulateTextFieldChange()
    }
}

private extension UITextField {

    func simulateTextFieldChange() {
        allTargets.forEach{ target in
            actions(forTarget: target, forControlEvent: .editingChanged)?.forEach {
                (target as NSObject).perform(Selector($0), with: self)
            }
        }
    }
}
