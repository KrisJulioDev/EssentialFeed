//
//  FeedImageLoaderPresentationAdapter.swift
//  EssentialFeediOS
//
//  Created by Khristoffer Julio on 11/13/23.
//

import Combine
import Foundation
import EssentialFeed
import EssentialFeediOS

final class FeedImageLoaderPresentationAdapter<View: FeedImageView, Image>: FeedImageCellControllerDelegate where View.Image == Image {
    
    private let model: FeedImage
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
    var presenter: FeedImagePresenter<View, Image>?
    var cancellable: Cancellable?
    
    init(model: FeedImage, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func didRequestImage() {
        presenter?.didStartLoadingImageData(for: model)
        
        cancellable = imageLoader(model.url)
            .dispatchOnMainQueue()
            .sink { [weak self, model] completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    self?.presenter?.didFinishLoadingImage(with: error, for: model)
                }
            } receiveValue: { [weak self, model] data in
                self?.presenter?.didStartLoadingImageData(with: data, for: model)
            }
    } 
    
    func didCancelImageRequest() {
        cancellable?.cancel()
    }
}
