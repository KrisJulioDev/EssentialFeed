//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Khristoffer Julio on 11/11/23.
//
 
import EssentialFeed
 
final class FeedViewModel {
    private let feedLoader: FeedLoader
    private var feed: [FeedImage]?
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var onChange: ((FeedViewModel) -> Void)?
    var onFeedLoad: (([FeedImage]) -> Void)?
    
    private(set) var isLoading: Bool = false {
        didSet { onChange?(self) }
    }
     
    @objc func loadFeed() {
        isLoading = true
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }
             
            self?.isLoading = false
        }
    }
}
