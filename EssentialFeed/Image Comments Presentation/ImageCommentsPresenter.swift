//
//  ImageCommentsPresenter.swift
//  EssentialFeed
//
//  Created by Khristoffer Julio on 11/22/23.
//

import Foundation

public final class ImageCommentsPresenter {
    public static var title: String {
        return NSLocalizedString("IMAGE_COMMENTS_VIEW_TITLE",
            tableName: "ImageComments",
            bundle: Bundle(for: FeedPresenter.self),
            comment: "Title for the Image comments view")
    }
    
//    public static func map(_ comments: [ImageComment]) -> ImageCommentsViewModel {
//         ImageCommentsViewModel(comments: comments)
//    }
}

public struct ImageCommentsViewModel {
    let comments: [ImageComment]
}
