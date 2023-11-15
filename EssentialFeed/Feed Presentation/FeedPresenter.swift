//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Khristoffer Julio on 11/13/23.
//

import Foundation

public protocol FeedView {
    func display(_ viewModel: FeedViewModel)
} 

public protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

public struct FeedErrorViewModel {
    public var message: String?
    
    public static var noError: FeedErrorViewModel {
        FeedErrorViewModel(message: nil)
    }
}

public protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

public final class FeedPresenter {
    private let feedView: FeedView
    private let loadingView: FeedLoadingView
    private let errorView: FeedErrorView
    
    public init(feedView: FeedView, loadingView: FeedLoadingView, errorView: FeedErrorView) {
        self.feedView = feedView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    public func didStartLoadingFeed() {
        errorView.display(.noError)
        loadingView.display(.init(isLoading: true))
    }
    
    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(.init(feed: feed))
        loadingView.display(.init(isLoading: false))
    }
    
    public func didFinishLoadingFeed(with error: Error) {
        errorView.display(.init(message: ""))
        loadingView.display(.init(isLoading: false))
    }
}
