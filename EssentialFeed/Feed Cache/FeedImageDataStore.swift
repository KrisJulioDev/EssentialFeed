//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Khristoffer Julio on 11/16/23.
//

import Foundation

public protocol FeedImageDataStore {
    typealias InsertionResult = Swift.Result<Void, Error>
    typealias RetrievalResult = Swift.Result<Data?, Error>
    
    func insert(_ data: Data, url: URL, completion: @escaping (InsertionResult) -> Void)
    func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void)
}
