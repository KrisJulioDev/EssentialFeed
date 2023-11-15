//
//  SharedItemsHelper.swift
//  EssentialAppTests
//
//  Created by Khristoffer Julio on 11/15/23.
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
