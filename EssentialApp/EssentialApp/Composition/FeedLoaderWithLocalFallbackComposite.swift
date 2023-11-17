//
//  RemoteLoaderWithLocalFallbackComposite.swift
//  EssentialApp
//
//  Created by Khristoffer Julio on 11/15/23.
//

import EssentialFeed

public final class FeedLoaderWithLocalFallbackComposite: FeedLoader {
    let primaryLoader: FeedLoader
    let fallbackLoader: FeedLoader
    
    public init(primaryLoader: FeedLoader, fallbackLoader: FeedLoader) {
        self.primaryLoader = primaryLoader
        self.fallbackLoader = fallbackLoader
    }
    
    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        primaryLoader.load { [weak self] result in
            switch result {
            case let .success(feed):
                completion(.success(feed))
            case .failure:
                self?.fallbackLoader.load(completion: completion)
            }
        }
    }
}
