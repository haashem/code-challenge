//
//  XCTestCase+MemoryLeakTracking.swift
//  ExchangeRateAPITests
//
//  Created by Hashem Aboonajmi on 1/1/21.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: #file, line: #line)
        }
    }
}
