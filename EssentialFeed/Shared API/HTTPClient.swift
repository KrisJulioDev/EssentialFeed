//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Khristoffer Julio on 11/5/23.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
} 

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    @discardableResult
    func get(from url: URL, completion: @escaping (Result) -> Void) -> HTTPClientTask
}
