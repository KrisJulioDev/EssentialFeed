//
//  RemoteFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Khristoffer Julio on 11/15/23.
//

import Foundation

protocol FeedImageDataLoaderTask {
    func cancel()
}

protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}

class RemoteFeedImageDataLoader: FeedImageDataLoader {
    
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    private class HTTPClientTaskWrapper: FeedImageDataLoaderTask {
        private(set) var completion: ((FeedImageDataLoader.Result) -> Void)?
        
        var wrapped: HTTPClientTask?
        
        init(_ completion: @escaping (FeedImageDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: FeedImageDataLoader.Result) {
            completion?(result)
        }
        
        func cancel() {
            preventFurtherCompletions()
            wrapped?.cancel()
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        
        let task = HTTPClientTaskWrapper(completion)
        
        task.wrapped = client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            task.complete(with: result
                .mapError { _ in Error.connectivity }
                .flatMap { data, response in
                    let isValidResponse = response.isOK && !data.isEmpty
                    return isValidResponse ? .success(data) : .failure(Error.invalidData)
                }
            )
        }
        
        return task
    }
    
}
