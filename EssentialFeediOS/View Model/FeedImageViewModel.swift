//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Khristoffer Julio on 11/11/23.
//

import Foundation
import UIKit
import EssentialFeed

final class FeedImageViewModel {
    typealias Observer<T> = (T) -> Void
    
    private let imageLoader: FeedImageDataLoader
    private let model: FeedImage
    private var task: FeedImageDataLoaderTask?
    
    init(model: FeedImage, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    var imageDescription: String? {
        model.description
    }
    
    var location: String? {
        model.location
    }
    
    var hasLocation: Bool {
        location != nil
    }

    var onImageLoad: Observer<UIImage>?
    var onImageLoadingStateChange: Observer<Bool>?
    var onShouldRetryImageLoadStateChange: Observer<Bool>?
    
    func loadImageData() {
        onImageLoadingStateChange?(true)
        onShouldRetryImageLoadStateChange?(false)
        
        task = imageLoader.loadImageData(from: model.url) { [weak self] result in
            self?.handleResult(result)
        }
    }
    
    private func handleResult(_ result: FeedImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(UIImage.init) {
            onImageLoad?(image)
        } else {
            onShouldRetryImageLoadStateChange?(true)
        }
        onImageLoadingStateChange?(false)
    }
    
    func cancelImageDataLoad() {
        task?.cancel()
    }
}
