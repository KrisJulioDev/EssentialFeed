//
//  LocalFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Khristoffer Julio on 11/16/23.
//

import Foundation
 
public final class LocalFeedImageDataLoader {
    let store: FeedImageDataStore
    
    public init(store: FeedImageDataStore) {
        self.store = store
    }
}

extension LocalFeedImageDataLoader {
    public typealias SaveResult = Swift.Result<Void, Error>

    public func save(_ data: Data, url: URL, completion: @escaping (SaveResult) -> Void) {
        store.insert(data, url: url, completion: completion)
    }
}

extension LocalFeedImageDataLoader: FeedImageDataLoader {
    
    public enum LoadError: Error {
        case failed
        case notFound
    }
    
    private class LoadImageDataTask: FeedImageDataLoaderTask {
        private var completion: ((FeedImageDataLoader.Result) -> Void)?
        
        init(completion: @escaping (FeedImageDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: FeedImageDataLoader.Result) {
            completion?(result)
        }
        
        func cancel() {
            preventFurtherCompletion()
        }
            
        func preventFurtherCompletion() {
            completion = nil
        }
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
         
        let task = LoadImageDataTask(completion: completion)
        store.retrieve(dataForURL: url) { [weak self] result in
            guard self != nil else { return }
            
            task.complete(with: result
                .mapError { _ in LoadError.failed }
                .flatMap { data in
                    data.map { .success($0) } ?? .failure(LoadError.notFound)
                }
            )
        }
        
        return task
    }
}
