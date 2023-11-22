//
//  FeedImagePresenter.swift
//  EssentialFeediOS
//
//  Created by Khristoffer Julio on 11/13/23.
//

import Foundation

public final class FeedImagePresenter {
    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        FeedImageViewModel(description: image.description, location: image.location)
    }
}

