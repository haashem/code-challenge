//
//  SharedTestHelpers.swift
//  ExchangeRateAPITests
//
//  Created by Hashem Aboonajmi on 1/1/21.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain:"any error", code: 0, userInfo: nil)
}

func anyURL() ->URL {
    return URL(string: "https://any-url.com")!
}

