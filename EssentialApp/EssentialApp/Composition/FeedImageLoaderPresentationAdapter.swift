//
//  FeedImageLoaderPresentationAdapter.swift
//  EssentialFeediOS
//
//  Created by Khristoffer Julio on 11/13/23.
//

import EssentialFeed
import EssentialFeediOS

final class FeedImageLoaderPresentationAdapter<View: FeedImageView, Image>: FeedImageCellControllerDelegate where View.Image == Image {
    
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    private var task: FeedImageDataLoaderTask?
    var presenter: FeedImagePresenter<View, Image>?
    
    init(model: FeedImage, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func didRequestImage() {
        presenter?.didStartLoadingImageData(for: model)
        
        task = imageLoader.loadImageData(from: model.url, completion: { [weak self, model] result in
            switch result {
            case let .success(data):
                self?.presenter?.didStartLoadingImageData(with: data, for: model)
            case let .failure(error):
                self?.presenter?.didFinishLoadingImage(with: error, for: model)
            }
        })
    }
    
    func didCancelRequestImage() {
        task?.cancel()
    }
}
