//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Khristoffer Julio on 11/7/23.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}
 
func anyData() -> Data {
    return Data("any data".utf8)
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
