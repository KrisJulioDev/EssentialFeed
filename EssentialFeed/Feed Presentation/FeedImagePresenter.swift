//
//  FeedImagePresenter.swift
//  EssentialFeediOS
//
//  Created by Khristoffer Julio on 11/13/23.
//

import Foundation

public protocol FeedImageView {
    associatedtype Image
    
    func display(_ model: FeedImageViewModel<Image>)
}

public final class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
    
    private let view: View
    private let imageTransformer: (Data) -> Image?
    
    public init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }
    
    public func didStartLoadingImageData(for model: FeedImage) {
        view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            image: nil,
            isLoading: true,
            shouldRetry: false))
    }
    
    private struct InvalidDataError: Error {}
    
    public func didStartLoadingImageData(with data: Data, for model: FeedImage) {
        
        guard let image = imageTransformer(data) else {
            return didFinishLoadingImage(with: InvalidDataError(), for: model)
        }
        
        view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            image: image,
            isLoading: false,
            shouldRetry: false))
    }
    
    public func didFinishLoadingImage(with error: Error, for model: FeedImage) {
        view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            image: nil, 
            isLoading: false,
            shouldRetry: true))
    }
}