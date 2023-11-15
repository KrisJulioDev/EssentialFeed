//
//  XCTest+Helpers.swift
//  EssentialAppTests
//
//  Created by Khristoffer Julio on 11/15/23.
//

import XCTest
 
extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
