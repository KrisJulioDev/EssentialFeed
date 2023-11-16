//
//  RemoteImageDataLoaderWithFallbackComposite.swift
//  EssentialApp
//
//  Created by Khristoffer Julio on 11/15/23.
//

import EssentialFeed
 
public final class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoader {
    let primaryLoader: FeedImageDataLoader
    let fallbackLoader: FeedImageDataLoader
    
    public init(primaryLoader: FeedImageDataLoader, fallbackLoader: FeedImageDataLoader) {
        self.primaryLoader = primaryLoader
        self.fallbackLoader = fallbackLoader
    }
    
    private class TaskWrapper: FeedImageDataLoaderTask {
        var wrapped: FeedImageDataLoaderTask?
        
        func cancel() {
            wrapped?.cancel()
        }
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void)
    -> FeedImageDataLoaderTask {
        let task = TaskWrapper()
        
        task.wrapped = primaryLoader.loadImageData(from: url) { [weak self] result in
            switch result {
            case let .success(data):
                completion(.success(data))
            case .failure:
                task.wrapped = self?.fallbackLoader.loadImageData(from: url, completion: completion)
            }
        }
        
        return task
    }
}
