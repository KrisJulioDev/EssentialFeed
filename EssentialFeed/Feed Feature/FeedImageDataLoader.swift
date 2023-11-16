//
//  FeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Khristoffer Julio on 11/16/23.
//

import Foundation

public protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}
