//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Khristoffer Julio on 11/11/23.
//

import EssentialFeed

protocol FeedLoadingView {
    func display(isLoading: Bool)
}

protocol FeedView {
    func display(feed: [FeedImage])
}

final class FeedPresenter {
    private let feedLoader: FeedLoader
    private var feed: [FeedImage]?
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var feedView: FeedView?
    var feedLoadingView: FeedLoadingView?
     
    @objc func loadFeed() {
        feedLoadingView?.display(isLoading: true)
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.feedView?.display(feed: feed)
            }
             
            self?.feedLoadingView?.display(isLoading: false)
        }
    }
}
