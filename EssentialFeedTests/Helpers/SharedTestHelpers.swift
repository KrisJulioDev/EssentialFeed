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