//
//  FeedLoaderPresentationAdapter.swift
//  EssentialFeediOS
//
//  Created by Khristoffer Julio on 11/13/23.
//

import Combine
import EssentialFeed
import EssentialFeediOS

public final class LoadResourcePresentationAdapter<Resource, View: ResourceView> {
    private let loader: () -> AnyPublisher<Resource, Error>
    var presenter: LoadResourcePresenter<Resource, View>?
    var cancellable: Cancellable?
    private var isLoading = false
    
    init(loader: @escaping () -> AnyPublisher<Resource, Error>) {
        self.loader = loader
    }
    
    func loadResource() {
        guard !isLoading else { return }
        
        presenter?.didStartLoading()
        isLoading = true
        
        cancellable = loader()
            .dispatchOnMainQueue() 
            .handleEvents(receiveCancel: { [weak self] in
                self?.isLoading = false
            })
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self?.presenter?.didFinishLoading(with: error)
                }
                self?.isLoading = false
            } receiveValue: { [weak self] resource in
                self?.presenter?.didFinishLoading(with: resource)
            }
    }
}

extension LoadResourcePresentationAdapter: FeedViewControllerDelegate {
    public func didRequestFeedRefresh() {
        loadResource()
    }
}

extension LoadResourcePresentationAdapter: FeedImageCellControllerDelegate {
    public func didRequestImage() {
        loadResource()
    }

    public func didCancelImageRequest() {
        cancellable?.cancel()
        cancellable = nil
    }
    
}
