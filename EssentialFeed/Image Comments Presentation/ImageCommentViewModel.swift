//
//  ImageCommentViewModel.swift
//  EssentialFeed
//
//  Created by Khristoffer Julio on 11/23/23.
//

import Foundation

public struct ImageCommentViewModel: Equatable {
    public let message: String
    public let date: String
    public let username: String
    
    public init(message: String, date: String, username: String) {
        self.message = message
        self.date = date
        self.username = username
    }
}

public struct ImageCommentsViewModel {
    public let comments: [ImageCommentViewModel]
}
